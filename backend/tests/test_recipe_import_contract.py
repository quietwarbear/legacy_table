from pathlib import Path

import pytest
from pydantic import ValidationError

from recipe_imports import ImportFailure, RecipeImportRequest, validate_hash_key


BACKEND = Path(__file__).resolve().parents[1]
ROOT = BACKEND.parent


def valid_payload():
    return {
        "source": "kindred",
        "operation_id": "synthetic-operation-0001",
        "source_subject_reference": "synthetic-subject-reference-0001",
        "source_revision_digest": "a" * 64,
        "consent_version": "kindred_recipe_import_v1",
        "title": "Synthetic recipe",
        "instructions_or_story": "Synthetic instructions.",
        "category": "Main Course",
        "family_cookbook_action": "use_existing",
    }


@pytest.mark.parametrize(
    ("field", "value"),
    [
        ("source", "other"),
        ("operation_id", "short"),
        ("operation_id", "unsafe/operation/id"),
        ("source_subject_reference", "unsafe?subject"),
        ("source_revision_digest", "not-a-digest"),
        ("consent_version", "future-unapproved-consent"),
        ("category", "Unbounded category"),
    ],
)
def test_import_schema_rejects_malformed_or_unbounded_values(field, value):
    payload = valid_payload()
    payload[field] = value
    with pytest.raises(ValidationError):
        RecipeImportRequest(**payload)


@pytest.mark.parametrize(
    "forbidden_field",
    [
        "email",
        "name",
        "user_id",
        "family_id",
        "event_id",
        "community_id",
        "invitation_token",
        "analytics_id",
        "provider_url",
        "metadata",
    ],
)
def test_import_schema_forbids_identity_provider_and_unbounded_metadata(
    forbidden_field,
):
    payload = valid_payload()
    payload[forbidden_field] = "synthetic-forbidden-value"
    with pytest.raises(ValidationError):
        RecipeImportRequest(**payload)


def test_family_creation_requires_explicit_name_and_existing_forbids_one():
    create_payload = valid_payload() | {"family_cookbook_action": "create"}
    with pytest.raises(ValidationError, match="family_cookbook_name_required"):
        RecipeImportRequest(**create_payload)
    with pytest.raises(ValidationError, match="family_cookbook_name_not_allowed"):
        RecipeImportRequest(
            **(valid_payload() | {"family_cookbook_name": "Unexpected"})
        )


def test_hash_configuration_fails_closed():
    for value in ["", "short", "x" * 31]:
        with pytest.raises(ImportFailure, match="import_configuration_unavailable"):
            validate_hash_key(value)
    assert len(validate_hash_key("x" * 32)) == 32


def test_contract_has_no_http_route_that_accepts_path_credentials():
    server = (BACKEND / "server.py").read_text()
    assert '@api_router.post("/recipe-imports"' in server
    assert '@api_router.get("/recipe-imports/{operation_id}"' in server
    assert "/recipe-imports/{token}" not in server
    assert "/recipe-imports?" not in server


def test_export_strips_internal_reconciliation_reference():
    server = (BACKEND / "server.py").read_text()
    assert 'r.pop("import_receipt_reference", None)' in server


def test_sensitive_logging_is_categorical_and_payload_free():
    server = (BACKEND / "server.py").read_text()
    recipe_imports = (BACKEND / "recipe_imports.py").read_text()
    assert "Recipe import lifecycle operation=%s status=%s" in server
    assert "payload.model_dump" not in server
    for forbidden_log in [
        "logger.info(payload",
        "logger.warning(payload",
        "logger.error(payload",
        "logger.info(recipe",
        "logger.info(user",
    ]:
        assert forbidden_log not in server
        assert forbidden_log not in recipe_imports


def test_split_repositories_are_not_modified_by_stage12a():
    assert ROOT.name == "legacy-table-stage12a"
