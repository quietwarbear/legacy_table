# Push Notifications (FCM) — the weekly family prompt

Firebase project: `legacy-table-push` — used **only** for FCM delivery.
MongoDB remains the only database; device tokens live in the `push_tokens`
collection, targeting logic lives in `server.py`.

## How it works

1. After login, HomeScreen calls `pushService.ensureRegistered()` — asks
   permission (post-login, never at cold boot), gets the FCM token, and
   registers it with `POST /api/push/register`.
2. Every Sunday 16:00–17:00 UTC, `weekly_prompt_loop()` (started in the
   FastAPI lifespan) sends that week's prompt to every registered device.
   Prompts rotate by ISO week from `WEEKLY_PROMPTS` — warm, brand-voice
   questions that all funnel toward recording a voice recipe.
3. Tapping the notification deep-links to the Voice Recipe screen
   (`route: /voice-recipe` in the data payload).
4. Dead tokens (FCM 400/404) are pruned automatically after each send.

Analytics: `push_permission_granted/denied`, `push_opened {route}` (PostHog).

## One-time setup still required

### 1. Backend credential (required for ANY sending)
Firebase console → ⚙ Project settings → **Service accounts** →
**Generate new private key** → downloads a JSON file. Put its ENTIRE
contents into a Railway variable named `FIREBASE_SERVICE_ACCOUNT`.
(This one is a real secret — never commit it.)

### 2. APNs key (required for iOS delivery; Android works without it)
1. developer.apple.com → Certificates, Identifiers & Profiles → **Keys** →
   ➕ → check **Apple Push Notifications service (APNs)** → register →
   download the `.p8` file (one chance!), note the **Key ID** and your
   **Team ID** (top right).
2. Firebase console → ⚙ Project settings → **Cloud Messaging** → under
   *Apple app configuration* → **Upload** the `.p8`, enter Key ID + Team ID.
3. Xcode may also need the Push Notifications capability reflected on the
   App ID — with automatic signing, building once after this branch merges
   normally syncs it (the `aps-environment` entitlement is already in
   `Runner.entitlements`).

### 3. Test before Sunday
Set `PUSH_ADMIN_EMAILS=<your-email>` on Railway, then (with the app
installed, logged in, permission granted):

```bash
TOKEN=<your login token>
curl -X POST https://api.legacytable.app/api/push/send-weekly-prompt \
  -H "Authorization: Bearer $TOKEN"
```

The response reports `{sent, failed}`. A notification should land on the
device within seconds.

## Play data-safety note
Push adds no new data categories beyond what's already declared (the FCM
token is an app identifier used for app functionality).
