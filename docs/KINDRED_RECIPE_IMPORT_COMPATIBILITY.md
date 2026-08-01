# Kindred → Legacy Table recipe-import compatibility contract

This is a destination contract only. It does not enable Kindred delivery.

## Endpoints and authentication

- Accept: `POST https://api.legacytable.app/api/recipe-imports`
- Reconcile: `GET https://api.legacytable.app/api/recipe-imports/{opaque_operation_id}`
- Authentication: `Authorization: Bearer <Legacy Table session>` produced by normal Legacy Table authentication or the single-use SSO flow.
- Caching: both responses are `Cache-Control: no-store`.

Kindred must never put the Legacy Table session, source reference, revision digest, or recipe content in a path or query string. Only the opaque operation ID appears in the reconciliation path.

## Exact request schema

```json
{
  "source": "kindred",
  "operation_id": "opaque-client-owned-id-minimum-16-chars",
  "source_subject_reference": "opaque-stable-recipe-subject-minimum-16-chars",
  "source_revision_digest": "64-lowercase-hex-characters",
  "consent_version": "kindred_recipe_import_v1",
  "title": "author-selected title, 1-200 characters",
  "instructions_or_story": "author-selected content, 1-20000 characters",
  "category": "Main Course",
  "family_cookbook_action": "use_existing",
  "family_cookbook_name": null
}
```

Every unlisted field is rejected. Allowed categories are `Appetizer`, `Beverage`, `Breakfast`, `Dessert`, `Main Course`, `Salad`, `Side Dish`, `Snack`, `Soup`, and `Other`.

For `family_cookbook_action: create`, `family_cookbook_name` is required and must contain the user's neutral, confirmed 1-80 character name. For `use_existing`, the name must be omitted or null.

The request must not contain names or emails as identity proof; invitation credentials; destination IDs; Kindred event, community, guest, RSVP, or family-access data; provider URLs or payloads; analytics identifiers; or arbitrary metadata.

## Safe response schema

```json
{
  "operation_id": "opaque-client-owned-id",
  "status": "accepted",
  "receipt_reference": "opaque-destination-receipt",
  "family_behavior": "existing_family"
}
```

Only `operation_id`, `status`, `receipt_reference`, `error_code`, and `family_behavior` may appear. Status values are `pending`, `accepted`, `already_accepted`, `rejected`, `conflict`, `deleted`, and `unavailable`. Family behavior is `existing_family` or `created_family`.

No response contains recipe content, customer identity, a family name, a database ID, an SSO/session credential, internal bindings, provider data, a stack trace, or infrastructure detail.

## Idempotency and retry rules

| Situation | Client action | Destination behavior |
| --- | --- | --- |
| HTTP 201 `accepted` | store receipt; stop submitting | exactly one recipe exists |
| HTTP 200 `accepted` or `already_accepted` | store receipt; stop submitting | prior acceptance reconciled |
| response lost or timeout is ambiguous | GET original operation ID before any POST retry | lookup recovers acceptance if committed |
| GET 404 after an ambiguous timeout | retry the identical POST with the same operation ID | no new ID until original state is resolved |
| `idempotency_payload_conflict` | stop | owner intervention; never change payload under the ID |
| `source_revision_conflict` | stop | explicit future update contract required |
| `family_creation_consent_required`, `family_choice_conflict`, `family_state_ambiguous`, `family_state_changed` | stop and return to user choice | no mutation is accepted |
| `transaction_unavailable`, `database_unavailable`, `import_configuration_unavailable`, `reconciliation_unavailable` | retry later with the same operation ID | destination failed closed |
| `deleted` / `recipe_deleted` | stop | tombstone prevents silent recreation |

Kindred must durably keep the original operation ID through crashes and must not automatically generate a replacement ID after an ambiguous result. A different operation ID for the same author/source subject/revision resolves to the original receipt and cannot create another recipe.

## SSO contract

Kindred mints the Legacy Table code server-to-server at `/api/auth/sso-code` using the shared server secret plus:

```json
{
  "audience": "legacy_table",
  "origin": "https://www.heykindred.org"
}
```

The Legacy Table landing redeems from browser origin `https://legacytable.app` with:

```json
{
  "code": "single-use authorization code",
  "audience": "legacy_table",
  "origin": "https://legacytable.app"
}
```

The Legacy Table page removes `?code=` before third-party initialization. Wrong audience/origin, expiry, reuse, malformed codes, redirects, or ambiguous canonical identity fail closed.

## Retention and deletion

- Operations: 400 days.
- Active receipts: retained with the recipe.
- Deleted recipes: content and destination recipe link removed; minimum keyed replay tombstone retained.
- Account erasure: imported content deleted and author binding irreversibly replaced by the account-erasure processor.
- Family deletion: imported content tombstoned transactionally with family deletion.
- Export: no operation, receipt, source digest, SSO state, or internal reconciliation field.
- Legacy Table and Kindred copies remain independently controlled.

## Required configuration names

- `MONGO_URL`
- `DB_NAME`
- `JWT_SECRET`
- `RECIPE_IMPORT_HASH_KEY`
- `UBUNTU_SSO_SECRET`
- `CORS_ORIGINS`
- `KINDRED_API_URL`
- `KINDRED_WEB_URL`

No value belongs in source control, reports, logs, analytics, or support output.

## Tests Kindred must add before enabling delivery

1. Exact request allowlist and bounded content/category validation.
2. Author-only preview and transfer authorization; organizer status must not substitute for authorship.
3. Stable operation ID persisted before the first request and reused after crash, timeout, app restart, and lost response.
4. Same-operation same-payload retry, divergent-payload conflict, different-operation same-revision convergence, and different-revision conflict.
5. Reconciliation GET before any retry after an ambiguous response.
6. No mutation of the Kindred source on destination failure, conflict, deletion, or unavailable state.
7. Explicit family action and unselected-by-default family-creation consent.
8. Header-only Legacy Table session transport; no credentials or content in paths, queries, browser history, analytics, tracing, logs, or reports.
9. Cross-account denial and session expiry/revocation.
10. Provider/network rejection, timeout-before-acceptance, timeout-after-acceptance, concurrent taps, and process interruption.
11. Safe projection of only status, error category, opaque operation ID, opaque receipt, and categorical family behavior.
12. Synthetic browser verification against the real built applications with third-party requests blocked.
13. Existing Kindred RSVP confidentiality, invitation transport, hidden-event visibility, notification isolation, service-worker bypass, and subscription HTTP 410 campaigns remain green.

Kindred delivery must remain fail-closed with `destination_idempotency_contract_required` until this destination PR is reviewed, merged, deployed with configuration and indexes, smoke-tested synthetically, and followed by a separately reviewed Kindred enablement PR.
