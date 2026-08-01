import asyncio
import importlib
import os
import uuid
from datetime import datetime, timedelta, timezone

import pytest
import pytest_asyncio
import httpx
from motor.motor_asyncio import AsyncIOMotorClient
from fastapi import HTTPException
from starlette.requests import Request
from starlette.responses import Response

from recipe_imports import (
    ImportFailure,
    RecipeImportRequest,
    accept_recipe_import,
    delete_family_with_import_tombstones,
    ensure_recipe_import_indexes,
    erase_recipe_import_author,
    reconcile_recipe_import,
    tombstone_imported_recipe,
)


MONGO_URL = os.environ.get("LEGACY_TABLE_DISPOSABLE_MONGO_URL", "")
HASH_KEY = "synthetic-recipe-import-hash-key-32-bytes-minimum"
pytestmark = pytest.mark.skipif(
    not MONGO_URL, reason="disposable Mongo replica set required"
)


def request(
    operation_id="synthetic-operation-0001",
    subject="synthetic-subject-reference-0001",
    revision="a" * 64,
    title="Synthetic holiday recipe",
    instructions="Synthetic instructions only.",
    action="use_existing",
    cookbook_name=None,
):
    return RecipeImportRequest(
        source="kindred",
        operation_id=operation_id,
        source_subject_reference=subject,
        source_revision_digest=revision,
        consent_version="kindred_recipe_import_v1",
        title=title,
        instructions_or_story=instructions,
        category="Main Course",
        family_cookbook_action=action,
        family_cookbook_name=cookbook_name,
    )


@pytest_asyncio.fixture
async def mongo():
    client = AsyncIOMotorClient(MONGO_URL, serverSelectionTimeoutMS=5_000)
    database = client[f"legacy_table_stage12a_{uuid.uuid4().hex}"]
    await client.admin.command("ping")
    await ensure_recipe_import_indexes(database)
    yield client, database
    await client.drop_database(database.name)
    client.close()


async def seed_user(database, user_id="synthetic-author", family_id="synthetic-family"):
    user = {
        "id": user_id,
        "name": "Synthetic Author",
        "email": f"{user_id}@example.invalid",
        "email_normalized": f"{user_id}@example.invalid",
        "created_at": "2026-01-01T00:00:00+00:00",
    }
    if family_id:
        user.update({"family_id": family_id, "role": "keeper"})
        await database.families.insert_one(
            {
                "id": family_id,
                "name": "Synthetic Cookbook",
                "owner_id": user_id,
                "invite_code": uuid.uuid4().hex[:8].upper(),
                "created_at": "2026-01-01T00:00:00+00:00",
            }
        )
    await database.users.insert_one(user)
    return user


@pytest.mark.asyncio
async def test_authenticated_import_retry_reconcile_and_record_privacy(mongo):
    client, database = mongo
    user = await seed_user(database)
    payload = request()

    accepted = await accept_recipe_import(database, client, user, payload, HASH_KEY)
    retried = await accept_recipe_import(database, client, user, payload, HASH_KEY)
    reconciled = await reconcile_recipe_import(
        database, user, payload.operation_id, HASH_KEY
    )

    assert accepted.status == "accepted"
    assert retried == accepted
    assert reconciled == accepted
    assert await database.recipes.count_documents({}) == 1
    assert await database.recipe_import_receipts.count_documents({}) == 1
    assert await database.recipe_import_operations.count_documents({}) == 1
    operational_records = repr(
        await database.recipe_import_operations.find({}, {"_id": 0}).to_list(10)
        + await database.recipe_import_receipts.find({}, {"_id": 0}).to_list(10)
    )
    for sensitive in [
        payload.title,
        payload.instructions_or_story,
        payload.source_subject_reference,
        payload.source_revision_digest,
    ]:
        assert sensitive not in operational_records


@pytest.mark.asyncio
async def test_same_operation_divergent_payload_fails_without_mutation(mongo):
    client, database = mongo
    user = await seed_user(database)
    payload = request()
    await accept_recipe_import(database, client, user, payload, HASH_KEY)

    with pytest.raises(ImportFailure, match="idempotency_payload_conflict"):
        await accept_recipe_import(
            database,
            client,
            user,
            request(title="Divergent synthetic title"),
            HASH_KEY,
        )
    assert await database.recipes.count_documents({}) == 1


@pytest.mark.asyncio
async def test_different_operation_same_revision_and_revision_conflict(mongo):
    client, database = mongo
    user = await seed_user(database)
    first = await accept_recipe_import(database, client, user, request(), HASH_KEY)
    duplicate = await accept_recipe_import(
        database,
        client,
        user,
        request(operation_id="synthetic-operation-0002"),
        HASH_KEY,
    )
    assert duplicate.status == "already_accepted"
    assert duplicate.receipt_reference == first.receipt_reference
    assert await database.recipes.count_documents({}) == 1

    with pytest.raises(ImportFailure, match="source_revision_conflict"):
        await accept_recipe_import(
            database,
            client,
            user,
            request(operation_id="synthetic-operation-0003", revision="b" * 64),
            HASH_KEY,
        )
    assert await database.recipes.count_documents({}) == 1


@pytest.mark.asyncio
async def test_concurrent_identical_and_different_operations_create_exactly_one_recipe(
    mongo,
):
    client, database = mongo
    user = await seed_user(database)
    identical = request(operation_id="synthetic-concurrent-identical")
    identical_results = await asyncio.gather(
        *[
            accept_recipe_import(database, client, user, identical, HASH_KEY)
            for _ in range(6)
        ]
    )
    assert {result.receipt_reference for result in identical_results}.__len__() == 1
    assert await database.recipes.count_documents({}) == 1

    await database.recipe_import_operations.delete_many({})
    await database.recipe_import_receipts.delete_many({})
    await database.recipes.delete_many({})
    operations = [f"synthetic-concurrent-divergent-{number}" for number in range(6)]
    results = await asyncio.gather(
        *[
            accept_recipe_import(
                database, client, user, request(operation_id=operation), HASH_KEY
            )
            for operation in operations
        ]
    )
    assert len({result.receipt_reference for result in results}) == 1
    assert await database.recipes.count_documents({}) == 1
    assert await database.recipe_import_operations.count_documents({}) == 6
    assert sum(result.status == "accepted" for result in results) == 1


@pytest.mark.asyncio
async def test_concurrent_divergent_payloads_and_revisions_fail_closed(mongo):
    client, database = mongo
    user = await seed_user(database)
    same_operation = await asyncio.gather(
        accept_recipe_import(
            database,
            client,
            user,
            request(operation_id="synthetic-divergent-same-op", title="Synthetic A"),
            HASH_KEY,
        ),
        accept_recipe_import(
            database,
            client,
            user,
            request(operation_id="synthetic-divergent-same-op", title="Synthetic B"),
            HASH_KEY,
        ),
        return_exceptions=True,
    )
    assert sum(not isinstance(result, Exception) for result in same_operation) == 1
    failure = next(result for result in same_operation if isinstance(result, Exception))
    assert isinstance(failure, ImportFailure)
    assert failure.code == "idempotency_payload_conflict"
    assert await database.recipes.count_documents({}) == 1

    await database.recipe_import_operations.delete_many({})
    await database.recipe_import_receipts.delete_many({})
    await database.recipes.delete_many({})
    divergent_revisions = await asyncio.gather(
        accept_recipe_import(
            database,
            client,
            user,
            request(operation_id="synthetic-revision-a", revision="a" * 64),
            HASH_KEY,
        ),
        accept_recipe_import(
            database,
            client,
            user,
            request(operation_id="synthetic-revision-b", revision="b" * 64),
            HASH_KEY,
        ),
        return_exceptions=True,
    )
    assert sum(not isinstance(result, Exception) for result in divergent_revisions) == 1
    failure = next(
        result for result in divergent_revisions if isinstance(result, Exception)
    )
    assert isinstance(failure, ImportFailure)
    assert failure.code == "source_revision_conflict"
    assert await database.recipes.count_documents({}) == 1


@pytest.mark.asyncio
async def test_lost_response_completed_retry_and_cross_account_denial(mongo):
    client, database = mongo
    owner = await seed_user(database)
    other = await seed_user(database, "synthetic-other", "synthetic-other-family")
    payload = request(operation_id="synthetic-lost-response")
    accepted = await accept_recipe_import(database, client, owner, payload, HASH_KEY)

    retry = await accept_recipe_import(database, client, owner, payload, HASH_KEY)
    assert retry.receipt_reference == accepted.receipt_reference
    with pytest.raises(ImportFailure, match="import_operation_not_found"):
        await reconcile_recipe_import(database, other, payload.operation_id, HASH_KEY)
    with pytest.raises(ImportFailure, match="import_operation_not_found"):
        await accept_recipe_import(database, client, other, payload, HASH_KEY)
    assert await database.recipes.count_documents({}) == 1


@pytest.mark.asyncio
async def test_family_consent_creation_ambiguity_and_transaction_rollback(mongo):
    client, database = mongo
    no_family = await seed_user(database, "synthetic-no-family", None)
    before = {
        "families": await database.families.count_documents({}),
        "recipes": await database.recipes.count_documents({}),
    }
    with pytest.raises(ImportFailure, match="family_creation_consent_required"):
        await accept_recipe_import(database, client, no_family, request(), HASH_KEY)
    assert await database.families.count_documents({}) == before["families"]
    assert await database.recipes.count_documents({}) == before["recipes"]
    assert await database.recipe_import_operations.count_documents({}) == 0

    created = await accept_recipe_import(
        database,
        client,
        no_family,
        request(
            operation_id="synthetic-create-family",
            action="create",
            cookbook_name="Our Synthetic Cookbook",
        ),
        HASH_KEY,
    )
    assert created.family_behavior == "created_family"
    assert (
        await database.families.count_documents({"name": "Our Synthetic Cookbook"}) == 1
    )

    ambiguous = await seed_user(database, "synthetic-ambiguous", "synthetic-family-a")
    await database.users.update_one(
        {"id": ambiguous["id"]},
        {"$set": {"family_ids": ["synthetic-family-a", "synthetic-family-b"]}},
    )
    counts = (
        await database.recipes.count_documents({}),
        await database.recipe_import_operations.count_documents({}),
    )
    with pytest.raises(ImportFailure, match="family_state_ambiguous"):
        await accept_recipe_import(
            database,
            client,
            ambiguous,
            request(
                operation_id="synthetic-ambiguous-operation",
                subject="synthetic-ambiguous-subject",
            ),
            HASH_KEY,
        )
    assert counts == (
        await database.recipes.count_documents({}),
        await database.recipe_import_operations.count_documents({}),
    )


@pytest.mark.asyncio
async def test_recipe_family_and_account_deletion_preserve_replay_tombstones(mongo):
    client, database = mongo
    owner = await seed_user(database)
    payload = request(operation_id="synthetic-delete-recipe")
    accepted = await accept_recipe_import(database, client, owner, payload, HASH_KEY)
    recipe = await database.recipes.find_one(
        {"import_receipt_reference": accepted.receipt_reference}
    )

    assert await tombstone_imported_recipe(database, client, recipe["id"])
    replay = await accept_recipe_import(
        database,
        client,
        owner,
        request(operation_id="synthetic-delete-replay"),
        HASH_KEY,
    )
    assert replay.status == "deleted"
    assert await database.recipes.count_documents({}) == 0
    receipt = await database.recipe_import_receipts.find_one({})
    assert "recipe_id" not in receipt

    family_owner = await seed_user(
        database, "synthetic-family-owner", "synthetic-family-delete"
    )
    family_import = await accept_recipe_import(
        database,
        client,
        family_owner,
        request(
            operation_id="synthetic-family-delete-op",
            subject="synthetic-family-delete-subject",
        ),
        HASH_KEY,
    )
    await delete_family_with_import_tombstones(
        database, client, "synthetic-family-delete"
    )
    assert (
        await database.recipes.count_documents(
            {"import_receipt_reference": family_import.receipt_reference}
        )
        == 0
    )
    assert (
        await database.recipe_import_receipts.find_one(
            {"receipt_reference": family_import.receipt_reference}
        )
    )["status"] == "deleted"

    account_owner = await seed_user(
        database, "synthetic-account-owner", "synthetic-account-family"
    )
    account_import = await accept_recipe_import(
        database,
        client,
        account_owner,
        request(
            operation_id="synthetic-account-delete-op",
            subject="synthetic-account-delete-subject",
        ),
        HASH_KEY,
    )
    assert (
        await erase_recipe_import_author(
            database, client, account_owner["id"], HASH_KEY
        )
        == 1
    )
    assert (
        await database.recipes.count_documents(
            {"import_receipt_reference": account_import.receipt_reference}
        )
        == 0
    )
    with pytest.raises(ImportFailure, match="import_operation_not_found"):
        await reconcile_recipe_import(
            database, account_owner, "synthetic-account-delete-op", HASH_KEY
        )


@pytest.mark.asyncio
async def test_missing_transaction_support_fails_closed_without_partial_state(
    monkeypatch, mongo
):
    client, database = mongo
    user = await seed_user(database)

    class UnavailableClient:
        async def start_session(self):
            from pymongo.errors import OperationFailure

            raise OperationFailure("synthetic transaction unavailable")

    with pytest.raises(ImportFailure, match="transaction_unavailable"):
        await accept_recipe_import(
            database, UnavailableClient(), user, request(), HASH_KEY
        )
    assert await database.recipe_import_operations.count_documents({}) == 0
    assert await database.recipe_import_receipts.count_documents({}) == 0
    assert await database.recipes.count_documents({}) == 0


def browser_request(origin="https://legacytable.app"):
    return Request(
        {
            "type": "http",
            "method": "POST",
            "path": "/api/auth/sso-redeem",
            "headers": [(b"origin", origin.encode("ascii"))],
        }
    )


@pytest.mark.asyncio
async def test_sso_is_digest_only_single_use_origin_bound_and_identity_safe(
    monkeypatch, mongo
):
    client, database = mongo
    monkeypatch.setenv("MONGO_URL", MONGO_URL)
    monkeypatch.setenv("DB_NAME", database.name)
    monkeypatch.setenv("JWT_SECRET", "synthetic-jwt-secret-with-sufficient-length")
    monkeypatch.setenv(
        "UBUNTU_SSO_SECRET", "synthetic-sso-secret-with-sufficient-length"
    )
    server = importlib.import_module("server")
    monkeypatch.setattr(server, "db", database)

    with pytest.raises(HTTPException) as retired_exchange:
        await server.auth_exchange(
            server.SSOExchangeRequest(
                email="retired.synthetic@example.invalid",
                name="Synthetic Retired User",
                secret="synthetic-sso-secret-with-sufficient-length",
            )
        )
    assert retired_exchange.value.status_code == 410

    trace_event = {
        "request": {
            "url": "https://api.example.invalid/api/recipe-imports?unsafe=marker",
            "data": "SENSITIVE_SYNTHETIC_BODY_MARKER",
            "query_string": "unsafe=marker",
            "cookies": "synthetic-cookie",
            "headers": {
                "Authorization": "synthetic-authorization",
                "Origin": "synthetic",
            },
        },
        "breadcrumbs": ["SENSITIVE_SYNTHETIC_BODY_MARKER"],
        "extra": {"payload": "SENSITIVE_SYNTHETIC_BODY_MARKER"},
        "spans": [{"data": {"db.statement": "SENSITIVE_SYNTHETIC_BODY_MARKER"}}],
    }
    sanitized_trace = server._privacy_safe_sentry_event(trace_event, None)
    assert "SENSITIVE_SYNTHETIC_BODY_MARKER" not in repr(sanitized_trace)
    assert "unsafe=marker" not in repr(sanitized_trace)
    assert sanitized_trace["request"]["headers"]["Authorization"] == "[Filtered]"

    mint_response = Response()
    minted = await server.sso_mint_code(
        server.SSOCodeRequest(
            email="MiXeD.Synthetic@example.invalid",
            name="Synthetic SSO User",
            secret="synthetic-sso-secret-with-sufficient-length",
            audience="legacy_table",
            origin="https://www.heykindred.org",
        ),
        mint_response,
    )
    assert mint_response.headers["cache-control"].startswith("no-store")
    stored = await database.sso_codes.find_one({})
    assert minted["code"] not in repr(stored)
    assert "code" not in stored
    assert len(stored["code_digest"]) == 64

    redeem_response = Response()
    redeemed = await server.sso_redeem_code(
        server.SSORedeemRequest(
            code=minted["code"],
            audience="legacy_table",
            origin="https://legacytable.app",
        ),
        browser_request(),
        redeem_response,
    )
    assert redeem_response.headers["cache-control"].startswith("no-store")
    assert redeemed.user.email == "mixed.synthetic@example.invalid"
    stored = await database.sso_codes.find_one({})
    assert stored["used"] is True
    assert "code_digest" not in stored

    with pytest.raises(HTTPException):
        await server.sso_redeem_code(
            server.SSORedeemRequest(
                code=minted["code"],
                audience="legacy_table",
                origin="https://legacytable.app",
            ),
            browser_request(),
            Response(),
        )

    expired = await server.sso_mint_code(
        server.SSOCodeRequest(
            email="expired.synthetic@example.invalid",
            name="Synthetic Expired User",
            secret="synthetic-sso-secret-with-sufficient-length",
            audience="legacy_table",
            origin="https://www.heykindred.org",
        ),
        Response(),
    )
    await database.sso_codes.update_one(
        {"code_digest": server._sso_code_digest(expired["code"])},
        {"$set": {"expires_at": datetime.now(timezone.utc) - timedelta(seconds=1)}},
    )
    with pytest.raises(HTTPException):
        await server.sso_redeem_code(
            server.SSORedeemRequest(
                code=expired["code"],
                audience="legacy_table",
                origin="https://legacytable.app",
            ),
            browser_request(),
            Response(),
        )

    for audience, source_origin in [
        ("wrong", "https://www.heykindred.org"),
        ("legacy_table", "https://wrong.example.invalid"),
    ]:
        with pytest.raises(HTTPException):
            await server.sso_mint_code(
                server.SSOCodeRequest(
                    email="rejected.synthetic@example.invalid",
                    name="Synthetic Rejected User",
                    secret="synthetic-sso-secret-with-sufficient-length",
                    audience=audience,
                    origin=source_origin,
                ),
                Response(),
            )

    for audience, landing_origin, request_origin in [
        ("wrong", "https://legacytable.app", "https://legacytable.app"),
        ("legacy_table", "https://wrong.example.invalid", "https://legacytable.app"),
        ("legacy_table", "https://legacytable.app", "https://wrong.example.invalid"),
    ]:
        with pytest.raises(HTTPException):
            await server.sso_redeem_code(
                server.SSORedeemRequest(
                    code="A" * 43,
                    audience=audience,
                    origin=landing_origin,
                ),
                browser_request(request_origin),
                Response(),
            )

    await database.users.insert_many(
        [
            {
                "id": "ambiguous-one",
                "email": "Ambiguous@example.invalid",
                "name": "Synthetic One",
                "created_at": "2026-01-01T00:00:00+00:00",
            },
            {
                "id": "ambiguous-two",
                "email": "ambiguous@EXAMPLE.invalid",
                "name": "Synthetic Two",
                "created_at": "2026-01-01T00:00:00+00:00",
            },
        ]
    )
    with pytest.raises(HTTPException, match="ambiguous"):
        await server._find_or_create_sso_user("ambiguous@example.invalid", "Synthetic")


@pytest.mark.asyncio
async def test_http_contract_requires_session_is_no_store_and_owner_scoped(
    monkeypatch, mongo, caplog
):
    client, database = mongo
    monkeypatch.setenv("MONGO_URL", MONGO_URL)
    monkeypatch.setenv("DB_NAME", database.name)
    monkeypatch.setenv("JWT_SECRET", "synthetic-jwt-secret-with-sufficient-length")
    monkeypatch.setenv("RECIPE_IMPORT_HASH_KEY", HASH_KEY)
    server = importlib.import_module("server")
    monkeypatch.setattr(server, "db", database)
    monkeypatch.setattr(server, "client", client)
    owner = await seed_user(database)
    other = await seed_user(
        database, "synthetic-http-other", "synthetic-http-other-family"
    )
    transport = httpx.ASGITransport(app=server.app)
    async with httpx.AsyncClient(
        transport=transport, base_url="https://api.example.invalid"
    ) as browser:
        anonymous = await browser.post(
            "/api/recipe-imports", json=request().model_dump()
        )
        assert anonymous.status_code in {401, 403}

        owner_headers = {"Authorization": f"Bearer {server.create_token(owner['id'])}"}
        accepted = await browser.post(
            "/api/recipe-imports",
            json=request(operation_id="synthetic-http-operation").model_dump(),
            headers=owner_headers,
        )
        assert accepted.status_code == 201
        assert accepted.headers["cache-control"].startswith("no-store")
        assert set(accepted.json()) <= {
            "operation_id",
            "status",
            "receipt_reference",
            "error_code",
            "family_behavior",
        }
        conflict = await browser.post(
            "/api/recipe-imports",
            json=request(
                operation_id="synthetic-http-operation",
                title="SENSITIVE_SYNTHETIC_TITLE_MARKER",
                instructions="SENSITIVE_SYNTHETIC_BODY_MARKER",
            ).model_dump(),
            headers=owner_headers,
        )
        assert conflict.status_code == 409
        assert conflict.json()["error_code"] == "idempotency_payload_conflict"
        assert "SENSITIVE_SYNTHETIC_TITLE_MARKER" not in caplog.text
        assert "SENSITIVE_SYNTHETIC_BODY_MARKER" not in caplog.text

        owner_lookup = await browser.get(
            "/api/recipe-imports/synthetic-http-operation",
            headers=owner_headers,
        )
        assert owner_lookup.status_code == 200
        assert owner_lookup.headers["cache-control"].startswith("no-store")

        other_headers = {"Authorization": f"Bearer {server.create_token(other['id'])}"}
        denied = await browser.get(
            "/api/recipe-imports/synthetic-http-operation",
            headers=other_headers,
        )
        assert denied.status_code == 404
        assert denied.json()["error_code"] == "import_operation_not_found"
