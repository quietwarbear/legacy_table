# Stage 12B — secure Kindred recipe import landing

Status: draft, unmerged, undeployed. This is the browser half of the coordinated Stage 12B bridge. The authoritative destination idempotency contract remains `docs/STAGE_12A_LEGACY_TABLE_RECIPE_IMPORT.md` and `docs/KINDRED_RECIPE_IMPORT_COMPATIBILITY.md`.

## Browser boundary

The `/sso` HTML bootstrap captures the existing SSO query code and the separate `#transfer=` credential before React or any third-party initialization, stores them only as non-enumerable transient window properties, and immediately replaces history with clean `/sso`. React deletes both properties before use. CookieYes, Google tags, PostHog initialization/identity/reset/capture, replay/autocapture, and service-worker registration remain suppressed for the entire sensitive document.

After SSO redemption, the page keeps the Legacy Table session within Legacy Table. It retrieves the Kindred payload with `X-Kindred-Transfer`, `credentials: omit`, `redirect: error`, `cache: no-store`, and `referrerPolicy: no-referrer`. It reconciles the original operation ID before any destination POST, requires an explicit family/cookbook choice, submits through the authenticated Stage 12A endpoint, and acknowledges the opaque result to Kindred with the grant header.

## Destination state and choices

| Observation | Browser action | Destination guarantee |
| --- | --- | --- |
| no eligible family | neutral name plus unchecked create confirmation | family and recipe share one transaction |
| one eligible family | unchecked existing-family confirmation | server revalidates current family |
| stale or multiple family state | stop on categorical conflict | zero mutation |
| existing operation accepted | acknowledge recovered receipt | no POST and no duplicate |
| operation absent | one POST with exact original payload | Stage 12A transaction/uniqueness |
| ambiguous POST response | reconcile same operation | never mint a replacement ID |
| deleted receipt | show safe deleted category | tombstone prevents recreation |
| explicit abandonment | best-effort header-only revocation, clear transient state | no recipe creation |
| terminal deletion/conflict acknowledgement | immediately discard the grant from React state | safe category only; no retry with retained credential |

## Privacy and reporting matrix

| Surface | Allowed | Prohibited |
| --- | --- | --- |
| URL/history/referrer | clean `/sso`; opaque operation in destination reconciliation path | grant, content, source reference, revision, session |
| browser persistence | existing Legacy session | SSO code, transfer grant, recipe payload, source binding |
| Kindred requests | transfer header and exact payload/ack bodies | Legacy session/cookies/redirects |
| Legacy requests | Legacy Bearer session and Stage 12A body | grant in path/query/body; Kindred identity assertion |
| UI/report | selected recipe, safe categories, opaque operation/receipt | names, emails, user/family/recipe IDs, provider payloads |
| analytics/tracing/logs | none for the sensitive document | identity, content, credentials, headers, bodies, URLs |

## Retry, retention, deletion, and rollback

Reloading after the bootstrap intentionally loses the transfer credential; the author resumes from Kindred, which issues a new short-lived grant for the same operation. A response loss is reconciled before another POST. An accepted destination receipt is immutable; a deleted destination copy remains tombstoned. Legacy Table and Kindred copies have independent deletion controls.

Rollout order: confirm `RECIPE_IMPORT_HASH_KEY`, transaction topology, and indexes; deploy this destination first; deploy Kindred with delivery disabled; verify commits; configure the exact Kindred API origin; run a synthetic smoke plan; enable Kindred last. Rollback disables Kindred issuance first and preserves destination reconciliation records.

Required configuration names, without values: `RECIPE_IMPORT_HASH_KEY`, `REACT_APP_KINDRED_API_ORIGIN`, `REACT_APP_BACKEND_URL`, `MONGO_URL`, `DB_NAME`, `JWT_SECRET`, `UBUNTU_SSO_SECRET`, and `CORS_ORIGINS`.

## Verification evidence and remaining gate

- Stage 12A backend contract, transactional import, family, deletion, SSO, and HTTP tests: 34 passed with a disposable replica set.
- Frontend unit/static: 6 passed after the final analytics, bounded-timeout, and credential-lifecycle guards.
- Production build and five-route prerender: passed.
- Built normal SSO isolation: passed.
- Built Kindred import flow: passed against the real built application with synthetic SSO, header-only Kindred retrieval, destination reconciliation/acceptance, acknowledgement, zero credential persistence, and all third-party executable/telemetry requests blocked. A clean production build was recreated afterward with the production Kindred origin default.
- OpenAPI, Python compilation, Black 26.1.0, `git diff --check`, credential/logging/provider/analytics/generated-artifact scans, and repository asset-isolation checks passed.

Production key/index/transaction readiness remains unverified because authenticated Railway metadata was unavailable in this task. No production configuration was read or changed. Delivery remains disabled pending both coordinated merges, deployments, provenance verification, and separately authorized activation.

The dependency scan retains the existing broader Legacy Table baseline of 3 low, 10 moderate, and 24 high advisories. This browser bridge adds no dependency or lockfile update; broader dependency remediation remains a separately tracked limitation.
