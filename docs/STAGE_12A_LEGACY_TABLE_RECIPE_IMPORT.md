# Stage 12A — Legacy Table idempotent recipe import

Status: draft, unmerged, undeployed. All behavioral verification used synthetic disposable records and a local disposable MongoDB replica set. No production customer data, provider history, secret, recipe, identity, or Kindred endpoint was accessed.

## Authoritative source and deployment provenance

The authoritative source is `quietwarbear/legacy_table`, not either older split repository.

| Surface | Repository | GitHub deployment | Source commit | Observed state |
| --- | --- | --- | --- | --- |
| Web production | `quietwarbear/legacy_table` | `5514595962` | `0b087365269774dd665376420b592b0d81703737` | success |
| API production | `quietwarbear/legacy_table` | `5514593019` (`Legacy Table / production`) | `0b087365269774dd665376420b592b0d81703737` | success |
| Old backend split | `quietwarbear/legacy_table_backend` | `4111888366` (`perpetual-amazement / new_root`) | `217ec260d7e58c903e3204d7857db08956f25f4b` | inactive, non-production |
| Old web split | `quietwarbear/legacy_table_web` | `4111888367` (`perpetual-amazement / new_root`) | `ad69ebb470f060bdfb87dfb16afe8bc3a4c93d01` | inactive, non-production |

The production commit contains the monorepo `backend`, `frontend`, and `mobile` applications. This change therefore uses one coordinated draft PR in that monorepo. The split repositories remain untouched.

## Threat model

The import boundary assumes a hostile or replaying client with a valid Legacy Table session, lost HTTP responses, concurrent submissions, changed payloads under reused operation IDs, different operation IDs for the same source revision, stale family state, and attempts by another account to inspect or claim an operation. It also assumes application logs, analytics, tracing, browser storage, referrers, and exports are disclosure surfaces.

The boundary does not trust a source-supplied name, email, user ID, family ID, provider URL, analytics identifier, invitation credential, or event/community/RSVP field. The authenticated Legacy Table session is the only ownership authority.

## Architecture and atomicity

`POST /api/recipe-imports` and `GET /api/recipe-imports/{operation_id}` require the existing Bearer session dependency. The POST validates the complete request before database work. It then creates or reconciles four durable facts in one MongoDB transaction:

1. the normal recipe document;
2. its authenticated author and resolved family association;
3. one replay-prevention receipt;
4. one operation-to-receipt acceptance record.

The route fails with `transaction_unavailable` when the database cannot provide transactions. It never falls back to separate writes. The operation and receipt collections use keyed HMAC bindings for the authenticated author, source subject, immutable revision, and canonical payload; raw source references, revision digests, recipe content, and customer identity are absent from reconciliation records.

### Durable uniqueness matrix

| Constraint | Database control | Result |
| --- | --- | --- |
| One `(source, operation_id)` | unique operation index | same ID cannot create another operation |
| One source subject per authenticated author | unique `(source, author_binding, source_subject_binding)` receipt index | different operation IDs converge on one receipt |
| One receipt reference | unique receipt index | receipt cannot alias two acceptances |
| One recipe per receipt | unique sparse recipe index | receipt cannot create two recipe documents |
| Different revision for an imported subject | stored keyed revision binding plus subject uniqueness | `source_revision_conflict` |

### State-transition matrix

| Starting observation | Request | Durable result | Returned category |
| --- | --- | --- | --- |
| none | valid first submission | recipe + receipt + operation commit together | `accepted` |
| accepted operation | same operation, identical canonical payload | no writes | `accepted` |
| accepted operation | same operation, divergent payload | no writes | `conflict` / `idempotency_payload_conflict` |
| accepted receipt | different operation, same author/subject/revision | alias operation only; no recipe | `already_accepted` |
| accepted receipt | different revision | no writes | `conflict` / `source_revision_conflict` |
| response lost after commit | same operation or GET | existing receipt recovered | `accepted` |
| transaction unavailable or aborts | any request | zero partial state | `unavailable` / `transaction_unavailable` |
| recipe deleted | same or new operation | tombstone retained; no recipe | `deleted` / `recipe_deleted` |
| another account | POST or GET for an existing operation | no writes and no existence disclosure | `rejected` / `import_operation_not_found` |

MongoDB resolves concurrent winners through the same unique constraints. A losing different-operation request creates only an alias to the winning receipt. A losing divergent revision fails closed.

## Authentication and identity

Normal Legacy Table authentication and hardened Ubuntu Markets SSO both produce the same Legacy Table session. The import request has no destination identity fields. Administrative or keeper status does not bypass operation ownership.

The SSO mint endpoint now requires the exact `legacy_table` audience and the allowlisted Kindred source origin. It stores only a SHA-256 digest of a random single-use code. Redemption atomically matches the digest, audience, expiry, unused state, exact landing origin, and browser `Origin`, then deletes the digest while marking the record used. The retired direct session exchange returns HTTP 410.

Legacy mixed-case email records are matched by exact case-insensitive canonical email. Exactly one record is reconciled to `email_normalized`; two matches fail with `SSO identity is ambiguous` and are never merged.

## Family behavior

The request must select one categorical action:

- `use_existing`: accepted only when the authenticated account resolves to exactly one existing family;
- `create`: accepted only when the account has no family and supplies a user-confirmed neutral cookbook name.

A missing family, multiple family references, a concurrent family change, implicit creation, or an attempt to create while already joined fails closed. Family creation, user membership, recipe creation, receipt creation, and operation acceptance share one transaction.

## Logging, tracing, analytics, and browser isolation

Import logs contain only the opaque operation ID, safe lifecycle category, and sanitized error code. The import implementation never logs request/response bodies, names, emails, content, cookbook names, source bindings, revision digests, destination IDs, tokens, headers, or provider data. Sentry request bodies, cookies, authorization headers, breadcrumbs, extras, and span data are stripped for the import and SSO endpoints, with local variables disabled globally.

The SSO HTML bootstrap captures the authorization code into transient non-enumerable memory and replaces browser history with `/sso` before CookieYes, Google tags, PostHog, or React initialize. CookieYes, Google tags, and PostHog remain enabled in production on non-sensitive pages. `/sso` receives `no-store`, `no-referrer`, and `noindex` headers. The page never writes the code to local storage, session storage, IndexedDB, Cache Storage, or a service worker.

## Retention, deletion, and export

- Operation records expire after 400 days through a TTL index. Receipt uniqueness remains after operation expiry, so expiry cannot permit a duplicate recipe.
- An active receipt remains while its imported recipe exists.
- Recipe deletion removes content and the internal recipe link in one transaction, while retaining only keyed source/revision bindings, the opaque receipt, categorical deletion state, and timestamps.
- Family deletion transactionally removes imported recipe content, tombstones receipts, detaches members, and removes the family. Existing non-import recipe deletion behavior is unchanged.
- The account-erasure processor must call `erase_recipe_import_author` before removing the user. It deletes imported content, replaces the author binding with a random keyed erasure binding, removes operation payload digests, and leaves a non-identifying replay tombstone. The existing public deletion-request intake remains asynchronous and does not authorize deletion by an unauthenticated email alone.
- Recipe export explicitly removes the internal import receipt reference. Operations, receipt bindings, SSO state, source digests, and reconciliation records have no export route.
- Deleting a Legacy Table copy does not delete the independent Kindred copy, and this PR makes no such claim.

## Verification evidence

| Campaign | Evidence |
| --- | --- |
| Backend unit/static and real replica-set integration | 34 passed |
| Concurrent same/different operation and divergent revision campaign | exactly one recipe and receipt; losing requests reconciled or conflicted |
| Transaction/family/preflight failure campaign | zero partial operation, receipt, family, or recipe state |
| Frontend Jest | 4 passed |
| Production web build and prerender | compiled; five public routes prerendered |
| Built-browser SSO isolation | passed with third-party traffic blocked; code absent from secondary URLs, referrers, storage, caches, and service-worker state |
| Flutter | 15 tests passed in a disposable copy |
| Android | debug APK built successfully under Java 21 in the disposable copy |
| iOS | unsigned device build succeeded in the disposable copy |
| OpenAPI | 66 paths; import POST and reconciliation GET present and authenticated |
| Python compile/fatal lint/format | passed; Black left the new Python files unchanged on repeat check |
| Mongo driver audit correction | PyMongo upgraded from vulnerable 4.5.0 to 4.17.0 with Motor 3.7.1; full tests remained green |
| Diff/artifact/credential/logging/provider-disable scans | passed for changed source; no generated native or web build artifact is staged |

The repository's existing dependency manifests still report baseline advisories: 43 Python advisories outside the upgraded Mongo driver and 37 frontend advisories in the unchanged Yarn lock graph. This narrowly scoped PR does not claim to remediate those unrelated dependency baselines. The existing ten React hook warnings also remain outside the modified SSO component.

## Deployment and operational gates

This PR must remain draft, unmerged, and undeployed pending owner review. A later deployment requires:

1. a MongoDB topology that supports transactions;
2. successful creation of all import uniqueness indexes;
3. a new server-only `RECIPE_IMPORT_HASH_KEY` of at least 32 random bytes;
4. the existing SSO and CORS configuration for the exact approved origins;
5. destination smoke tests with synthetic accounts only;
6. a separate Kindred PR implementing the compatibility contract;
7. a final owner decision before enabling Kindred delivery.

No provider call, customer communication, store publication, production mutation, or Kindred change belongs to this stage.
