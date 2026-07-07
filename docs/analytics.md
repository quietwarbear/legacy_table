# Analytics & Crash Reporting

Everything is **key-gated and off by default**. No keys are committed to the
repo; supply them at build/deploy time and the SDKs activate.

## Turning it on

| Surface | Tool | How to supply the key |
|---|---|---|
| Mobile (Flutter) | PostHog | `--dart-define=POSTHOG_API_KEY=phc_xxx` (optionally `POSTHOG_HOST`, defaults to US cloud) |
| Mobile (Flutter) | Sentry | `--dart-define=SENTRY_DSN=https://xxx@oXXX.ingest.sentry.io/XXX` |
| Backend (FastAPI/Railway) | Sentry | Set `SENTRY_DSN` service variable in Railway (optional `SENTRY_ENVIRONMENT`) |
| Web (marketing + web app) | GA4 | Already live (`G-Z0GP0D3ET0` in `frontend/public/index.html`) |

Xcode Cloud: add the two `--dart-define` flags to the build command in
`mobile/ios/ci_scripts/ci_post_clone.sh` (or set them as Xcode Cloud
environment variables and interpolate). Play builds: add the same flags to
whatever `flutter build appbundle` invocation produces the release.

Accounts to create (both have generous free tiers):
- PostHog: https://posthog.com → project → copy the `phc_…` project API key
- Sentry: https://sentry.io → one Flutter project + one Python project → copy each DSN

## Mobile event schema (PostHog)

Names are stable API — dashboards and funnels depend on them.

| Event | Fired when | Properties |
|---|---|---|
| `signup` | account created (any method) | `method`: email/google/apple/facebook |
| `login` | returning sign-in | `method` |
| `family_created` | POST /families succeeds | — |
| `family_joined` | invite code redeemed | — |
| `sample_family_created` | Quick Start seeded | — |
| `recipe_created` | recipe saved | `has_story`, `has_photos` |
| `first_recipe_created` | first-ever recipe (first-value milestone) | — |
| `ai_scan_used` / `ai_voice_used` / `ai_link_used` | AI capture succeeded | — |
| `invite_shared` | share sheet completed from invite dialog | `mode`: link/code |
| `review_prompt_requested` | native review prompt requested | — |
| `subscription_purchased` | RevenueCat purchase returned | `product_id`, `price`, `currency` |

Identity: `analytics.identify(<backend user id>)` on signup/login,
`analytics.reset()` on logout. No emails or names are sent as identifiers.

**The core funnel to build in PostHog:**
`signup → family_created OR family_joined → first_recipe_created → invite_shared → family_joined (by the invitee) → subscription_purchased`

## Web events (GA4)

| Event | Fired when | Params |
|---|---|---|
| `store_badge_click` | any App Store / Play badge or link clicked | `store`: apple/google · `placement`: hero/footer_cta/pricing/invite |

This is the web→store conversion metric. With Google Ads running, import
`store_badge_click` as a conversion in GA4/Ads to stop optimizing blind.

## Meta (Facebook) SDK

- iOS: already configured via Info.plist.
- Android: now configured (`android/app/src/main/res/values/strings.xml` +
  manifest meta-data) — previously the plugin silently no-op'd on Android.
- Events: `fb_mobile_login` (existing) + `logPurchase` on subscription
  purchase (new) — gives Meta ads revenue-based optimization signal.

## Play data-safety reminder

Adding PostHog/Sentry means the Play data-safety form must declare analytics
and crash data collection. Fold this into the correction already queued in
`docs/store_console_checklist.md`.
