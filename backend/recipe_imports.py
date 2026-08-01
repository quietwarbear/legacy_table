"""Transactional, privacy-safe recipe imports from trusted sibling products.

The public API is intentionally small.  Customer content is stored only in the
normal recipe document; reconciliation records contain keyed digests and opaque
references, never source identifiers or content.
"""

from __future__ import annotations

import hashlib
import hmac
import json
import secrets
import uuid
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from typing import Literal, Optional

from pydantic import BaseModel, ConfigDict, Field, model_validator
from pymongo import ASCENDING, ReturnDocument
from pymongo.errors import DuplicateKeyError, OperationFailure, PyMongoError


IMPORT_SOURCE = "kindred"
IMPORT_CONSENT_VERSION = "kindred_recipe_import_v1"
IMPORT_OPERATION_RETENTION_DAYS = 400
ALLOWED_CATEGORIES = (
    "Appetizer",
    "Beverage",
    "Breakfast",
    "Dessert",
    "Main Course",
    "Salad",
    "Side Dish",
    "Snack",
    "Soup",
    "Other",
)

OpaqueOperationId = str


class RecipeImportRequest(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)

    source: Literal["kindred"]
    operation_id: str = Field(
        min_length=16, max_length=128, pattern=r"^[A-Za-z0-9][A-Za-z0-9._:-]+$"
    )
    source_subject_reference: str = Field(
        min_length=16,
        max_length=256,
        pattern=r"^[A-Za-z0-9][A-Za-z0-9._:-]+$",
    )
    source_revision_digest: str = Field(pattern=r"^[a-f0-9]{64}$")
    consent_version: Literal["kindred_recipe_import_v1"]
    title: str = Field(min_length=1, max_length=200)
    instructions_or_story: str = Field(min_length=1, max_length=20_000)
    category: Literal[
        "Appetizer",
        "Beverage",
        "Breakfast",
        "Dessert",
        "Main Course",
        "Salad",
        "Side Dish",
        "Snack",
        "Soup",
        "Other",
    ]
    family_cookbook_action: Literal["use_existing", "create"]
    family_cookbook_name: Optional[str] = Field(
        default=None, min_length=1, max_length=80
    )

    @model_validator(mode="after")
    def validate_family_choice(self):
        if self.family_cookbook_action == "create" and not self.family_cookbook_name:
            raise ValueError("family_cookbook_name_required")
        if (
            self.family_cookbook_action == "use_existing"
            and self.family_cookbook_name is not None
        ):
            raise ValueError("family_cookbook_name_not_allowed")
        return self


class RecipeImportResult(BaseModel):
    model_config = ConfigDict(extra="forbid")

    operation_id: OpaqueOperationId
    status: Literal[
        "pending",
        "accepted",
        "already_accepted",
        "rejected",
        "conflict",
        "deleted",
        "unavailable",
    ]
    receipt_reference: Optional[str] = None
    error_code: Optional[str] = None
    family_behavior: Optional[Literal["existing_family", "created_family"]] = None


@dataclass(frozen=True)
class ImportFailure(Exception):
    code: str
    http_status: int
    safe_status: str = "conflict"


def validate_hash_key(value: str) -> bytes:
    key = (value or "").encode("utf-8")
    if len(key) < 32:
        raise ImportFailure("import_configuration_unavailable", 503, "unavailable")
    return key


def _keyed_digest(key: bytes, category: str, value: str) -> str:
    return hmac.new(
        key, f"{category}\0{value}".encode("utf-8"), hashlib.sha256
    ).hexdigest()


def _payload_digest(key: bytes, payload: RecipeImportRequest) -> str:
    canonical = payload.model_dump(exclude={"operation_id"}, mode="json")
    encoded = json.dumps(
        canonical, sort_keys=True, separators=(",", ":"), ensure_ascii=False
    )
    return _keyed_digest(key, "payload", encoded)


def _now() -> datetime:
    return datetime.now(timezone.utc)


def _result_from_records(
    operation: dict, receipt: Optional[dict]
) -> RecipeImportResult:
    if not receipt:
        return RecipeImportResult(
            operation_id=operation["operation_id"],
            status="unavailable",
            error_code="reconciliation_unavailable",
        )
    receipt_status = receipt.get("status")
    status = (
        "deleted"
        if receipt_status == "deleted"
        else operation.get("status", "accepted")
    )
    return RecipeImportResult(
        operation_id=operation["operation_id"],
        status=status,
        receipt_reference=receipt.get("receipt_reference"),
        error_code="recipe_deleted" if status == "deleted" else None,
        family_behavior=receipt.get("family_behavior"),
    )


async def ensure_recipe_import_indexes(database) -> None:
    """Create the durable uniqueness and retention controls used by the contract."""
    await database.recipe_import_operations.create_index(
        [("source", ASCENDING), ("operation_id", ASCENDING)],
        unique=True,
        name="recipe_import_operation_unique",
    )
    await database.recipe_import_operations.create_index(
        "expires_at",
        expireAfterSeconds=0,
        name="recipe_import_operation_retention",
    )
    await database.recipe_import_receipts.create_index(
        [
            ("source", ASCENDING),
            ("author_binding", ASCENDING),
            ("source_subject_binding", ASCENDING),
        ],
        unique=True,
        name="recipe_import_source_subject_unique",
    )
    await database.recipe_import_receipts.create_index(
        "receipt_reference",
        unique=True,
        name="recipe_import_receipt_unique",
    )
    await database.recipes.create_index(
        "import_receipt_reference",
        unique=True,
        sparse=True,
        name="recipe_import_recipe_receipt_unique",
    )


async def _existing_operation(
    database, operation_id: str, author_binding: str, payload_digest: str
):
    operation = await database.recipe_import_operations.find_one(
        {"source": IMPORT_SOURCE, "operation_id": operation_id},
        {"_id": 0},
    )
    if not operation:
        return None
    if not hmac.compare_digest(operation.get("author_binding", ""), author_binding):
        raise ImportFailure("import_operation_not_found", 404, "rejected")
    if not hmac.compare_digest(operation.get("payload_digest", ""), payload_digest):
        raise ImportFailure("idempotency_payload_conflict", 409)
    receipt = await database.recipe_import_receipts.find_one(
        {"receipt_reference": operation.get("receipt_reference")},
        {"_id": 0},
    )
    return _result_from_records(operation, receipt)


async def _resolve_family(
    database, user_id: str, payload: RecipeImportRequest, session
):
    current_user = await database.users.find_one({"id": user_id}, session=session)
    if not current_user:
        raise ImportFailure("authenticated_author_unavailable", 401, "rejected")

    family_ids = {
        value
        for value in current_user.get("family_ids", [])
        if isinstance(value, str) and value
    }
    if current_user.get("family_id"):
        family_ids.add(current_user["family_id"])
    if len(family_ids) > 1:
        raise ImportFailure("family_state_ambiguous", 409)

    existing_family_id = next(iter(family_ids), None)
    if existing_family_id:
        if payload.family_cookbook_action != "use_existing":
            raise ImportFailure("family_choice_conflict", 409)
        family = await database.families.find_one(
            {"id": existing_family_id}, session=session
        )
        if not family:
            raise ImportFailure("family_state_ambiguous", 409)
        return current_user, existing_family_id, "existing_family"

    if payload.family_cookbook_action != "create":
        raise ImportFailure("family_creation_consent_required", 409)

    family_id = str(uuid.uuid4())
    family = {
        "id": family_id,
        "name": payload.family_cookbook_name,
        "owner_id": user_id,
        "invite_code": secrets.token_hex(4).upper(),
        "metadata": {"created_for": "recipe_import"},
        "created_at": _now().isoformat(),
    }
    await database.families.insert_one(family, session=session)
    updated = await database.users.find_one_and_update(
        {
            "id": user_id,
            "$or": [
                {"family_id": {"$exists": False}},
                {"family_id": None},
                {"family_id": ""},
            ],
        },
        {"$set": {"family_id": family_id, "role": "keeper"}},
        return_document=ReturnDocument.AFTER,
        session=session,
    )
    if not updated:
        raise ImportFailure("family_state_changed", 409)
    return updated, family_id, "created_family"


async def _insert_alias_operation(
    database,
    payload: RecipeImportRequest,
    author_binding: str,
    payload_digest: str,
    receipt: dict,
    session,
):
    now = _now()
    operation = {
        "source": IMPORT_SOURCE,
        "operation_id": payload.operation_id,
        "author_binding": author_binding,
        "payload_digest": payload_digest,
        "status": (
            "deleted" if receipt.get("status") == "deleted" else "already_accepted"
        ),
        "receipt_reference": receipt["receipt_reference"],
        "created_at": now,
        "updated_at": now,
        "expires_at": now + timedelta(days=IMPORT_OPERATION_RETENTION_DAYS),
    }
    await database.recipe_import_operations.insert_one(operation, session=session)
    return _result_from_records(operation, receipt)


async def accept_recipe_import(
    database, mongo_client, user: dict, payload: RecipeImportRequest, hash_key: str
):
    """Accept once, or reconcile an existing acceptance without another recipe."""
    key = validate_hash_key(hash_key)
    user_id = user.get("id")
    if not isinstance(user_id, str) or not user_id:
        raise ImportFailure("authenticated_author_unavailable", 401, "rejected")

    author_binding = _keyed_digest(key, "author", user_id)
    subject_binding = _keyed_digest(
        key, "source_subject", payload.source_subject_reference
    )
    revision_binding = _keyed_digest(
        key, "source_revision", payload.source_revision_digest
    )
    payload_digest = _payload_digest(key, payload)

    existing = await _existing_operation(
        database, payload.operation_id, author_binding, payload_digest
    )
    if existing:
        return existing

    async def transaction_body(session):
        operation = await database.recipe_import_operations.find_one(
            {"source": IMPORT_SOURCE, "operation_id": payload.operation_id},
            session=session,
        )
        if operation:
            if not hmac.compare_digest(
                operation.get("author_binding", ""), author_binding
            ):
                raise ImportFailure("import_operation_not_found", 404, "rejected")
            if not hmac.compare_digest(
                operation.get("payload_digest", ""), payload_digest
            ):
                raise ImportFailure("idempotency_payload_conflict", 409)
            receipt = await database.recipe_import_receipts.find_one(
                {"receipt_reference": operation.get("receipt_reference")},
                session=session,
            )
            return _result_from_records(operation, receipt)

        receipt = await database.recipe_import_receipts.find_one(
            {
                "source": IMPORT_SOURCE,
                "author_binding": author_binding,
                "source_subject_binding": subject_binding,
            },
            session=session,
        )
        if receipt:
            if not hmac.compare_digest(
                receipt.get("source_revision_binding", ""), revision_binding
            ):
                raise ImportFailure("source_revision_conflict", 409)
            return await _insert_alias_operation(
                database,
                payload,
                author_binding,
                payload_digest,
                receipt,
                session,
            )

        current_user, family_id, family_behavior = await _resolve_family(
            database, user_id, payload, session
        )
        now = _now()
        receipt_reference = secrets.token_urlsafe(24)
        recipe_id = str(uuid.uuid4())
        recipe = {
            "id": recipe_id,
            "family_id": family_id,
            "title": payload.title,
            "ingredients": [],
            "instructions": payload.instructions_or_story,
            "story": None,
            "photos": [],
            "cooking_time": 0,
            "servings": 0,
            "category": payload.category,
            "difficulty": "easy",
            "author_id": user_id,
            "author_name": current_user.get("nickname")
            or current_user.get("name")
            or "Recipe author",
            "created_at": now.isoformat(),
            "import_receipt_reference": receipt_reference,
        }
        receipt = {
            "source": IMPORT_SOURCE,
            "author_binding": author_binding,
            "source_subject_binding": subject_binding,
            "source_revision_binding": revision_binding,
            "receipt_reference": receipt_reference,
            "recipe_id": recipe_id,
            "status": "accepted",
            "family_behavior": family_behavior,
            "created_at": now,
            "updated_at": now,
        }
        operation = {
            "source": IMPORT_SOURCE,
            "operation_id": payload.operation_id,
            "author_binding": author_binding,
            "payload_digest": payload_digest,
            "status": "accepted",
            "receipt_reference": receipt_reference,
            "created_at": now,
            "updated_at": now,
            "expires_at": now + timedelta(days=IMPORT_OPERATION_RETENTION_DAYS),
        }
        await database.recipes.insert_one(recipe, session=session)
        await database.recipe_import_receipts.insert_one(receipt, session=session)
        await database.recipe_import_operations.insert_one(operation, session=session)
        return _result_from_records(operation, receipt)

    try:
        async with await mongo_client.start_session() as session:
            return await session.with_transaction(transaction_body)
    except ImportFailure:
        raise
    except DuplicateKeyError:
        existing = await _existing_operation(
            database, payload.operation_id, author_binding, payload_digest
        )
        if existing:
            return existing
        receipt = await database.recipe_import_receipts.find_one(
            {
                "source": IMPORT_SOURCE,
                "author_binding": author_binding,
                "source_subject_binding": subject_binding,
            },
            {"_id": 0},
        )
        if receipt and not hmac.compare_digest(
            receipt.get("source_revision_binding", ""), revision_binding
        ):
            raise ImportFailure("source_revision_conflict", 409)
        if receipt:
            try:
                async with await mongo_client.start_session() as session:

                    async def alias_body(active_session):
                        return await _insert_alias_operation(
                            database,
                            payload,
                            author_binding,
                            payload_digest,
                            receipt,
                            active_session,
                        )

                    return await session.with_transaction(alias_body)
            except DuplicateKeyError:
                existing = await _existing_operation(
                    database, payload.operation_id, author_binding, payload_digest
                )
                if existing:
                    return existing
        raise ImportFailure("import_conflict", 409)
    except (OperationFailure, PyMongoError) as exc:
        raise ImportFailure("transaction_unavailable", 503, "unavailable") from exc


async def reconcile_recipe_import(
    database, user: dict, operation_id: str, hash_key: str
):
    key = validate_hash_key(hash_key)
    user_id = user.get("id")
    if not isinstance(user_id, str) or not user_id:
        raise ImportFailure("authenticated_author_unavailable", 401, "rejected")
    author_binding = _keyed_digest(key, "author", user_id)
    operation = await database.recipe_import_operations.find_one(
        {"source": IMPORT_SOURCE, "operation_id": operation_id},
        {"_id": 0},
    )
    if not operation or not hmac.compare_digest(
        operation.get("author_binding", ""), author_binding
    ):
        raise ImportFailure("import_operation_not_found", 404, "rejected")
    receipt = await database.recipe_import_receipts.find_one(
        {"receipt_reference": operation.get("receipt_reference")},
        {"_id": 0},
    )
    return _result_from_records(operation, receipt)


async def tombstone_imported_recipe(database, mongo_client, recipe_id: str) -> bool:
    """Delete imported content and retain only the minimum replay tombstone."""

    async def transaction_body(session):
        recipe = await database.recipes.find_one(
            {"id": recipe_id, "import_receipt_reference": {"$exists": True}},
            session=session,
        )
        if not recipe:
            return False
        receipt_reference = recipe["import_receipt_reference"]
        now = _now()
        await database.recipe_import_receipts.update_one(
            {"receipt_reference": receipt_reference, "status": "accepted"},
            {
                "$set": {"status": "deleted", "deleted_at": now, "updated_at": now},
                "$unset": {"recipe_id": ""},
            },
            session=session,
        )
        await database.recipe_import_operations.update_many(
            {"receipt_reference": receipt_reference},
            {"$set": {"status": "deleted", "updated_at": now}},
            session=session,
        )
        await database.recipes.delete_one({"id": recipe_id}, session=session)
        return True

    async with await mongo_client.start_session() as session:
        return await session.with_transaction(transaction_body)


async def delete_family_with_import_tombstones(
    database, mongo_client, family_id: str
) -> None:
    """Delete a family while atomically tombstoning imported recipe content."""

    async def transaction_body(session):
        imported_recipes = await database.recipes.find(
            {"family_id": family_id, "import_receipt_reference": {"$exists": True}},
            session=session,
        ).to_list(length=10_000)
        now = _now()
        for recipe in imported_recipes:
            receipt_reference = recipe["import_receipt_reference"]
            await database.recipe_import_receipts.update_one(
                {"receipt_reference": receipt_reference},
                {
                    "$set": {"status": "deleted", "deleted_at": now, "updated_at": now},
                    "$unset": {"recipe_id": ""},
                },
                session=session,
            )
            await database.recipe_import_operations.update_many(
                {"receipt_reference": receipt_reference},
                {"$set": {"status": "deleted", "updated_at": now}},
                session=session,
            )
            await database.recipes.delete_one({"id": recipe["id"]}, session=session)
        await database.users.update_many(
            {"family_id": family_id},
            {"$unset": {"family_id": "", "role": ""}},
            session=session,
        )
        deleted = await database.families.delete_one({"id": family_id}, session=session)
        if deleted.deleted_count != 1:
            raise ImportFailure("family_state_changed", 409)

    async with await mongo_client.start_session() as session:
        await session.with_transaction(transaction_body)


async def erase_recipe_import_author(
    database, mongo_client, user_id: str, hash_key: str
) -> int:
    """Remove imported content and sever reconciliation ownership during account erasure."""
    key = validate_hash_key(hash_key)
    author_binding = _keyed_digest(key, "author", user_id)

    async def transaction_body(session):
        receipts = await database.recipe_import_receipts.find(
            {"author_binding": author_binding},
            session=session,
        ).to_list(length=10_000)
        for receipt in receipts:
            replacement_binding = _keyed_digest(
                key, "erased_author", secrets.token_urlsafe(32)
            )
            recipe_id = receipt.get("recipe_id")
            if recipe_id:
                await database.recipes.delete_one({"id": recipe_id}, session=session)
            await database.recipe_import_receipts.update_one(
                {"_id": receipt["_id"]},
                {
                    "$set": {
                        "author_binding": replacement_binding,
                        "status": "deleted",
                        "deleted_at": _now(),
                        "updated_at": _now(),
                    },
                    "$unset": {"recipe_id": ""},
                },
                session=session,
            )
            await database.recipe_import_operations.update_many(
                {"receipt_reference": receipt["receipt_reference"]},
                {
                    "$set": {
                        "author_binding": replacement_binding,
                        "status": "deleted",
                        "updated_at": _now(),
                    },
                    "$unset": {"payload_digest": ""},
                },
                session=session,
            )
        return len(receipts)

    async with await mongo_client.start_session() as session:
        return await session.with_transaction(transaction_body)
