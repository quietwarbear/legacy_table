# TikTok App Events SDK (mobile)

Ad attribution for TikTok App Promotion campaigns (Keep The Record).

## What is wired

| Event | When | Where |
|---|---|---|
| Install, app launch | automatic | native SDK |
| `Registration` | new account, any method (email, Google, Apple, Facebook) | `AnalyticsService.capture('signup')` |
| `Subscribe` | a paid tier is purchased (with value + currency) | `SubscriptionService.purchasePackage` |
| identify / logout | login, logout (backend user id only) | `AnalyticsService.identify` / `reset` |

Dart wrapper: `mobile/lib/services/tiktok_events.dart`.
Native halves: `mobile/ios/Runner/AppDelegate.swift`,
`mobile/android/.../MainActivity.kt`. Channel: `app.legacytable/tiktok_events`.

## IDs and secrets

The TikTok App IDs are committed in `AppConfig`. The App Secrets are not.
Without a secret the SDK is never initialised and nothing is sent.

```bash
# iOS
flutter build ipa --dart-define=TIKTOK_APP_SECRET_IOS=<secret>
# Android
flutter build appbundle --dart-define=TIKTOK_APP_SECRET_ANDROID=<secret>
```

Xcode Cloud: add `TIKTOK_APP_SECRET_IOS` as a secret environment variable on
the workflow; `ci_post_clone.sh` passes it through.

## After pulling this change

```bash
cd mobile && flutter pub get
cd ios && pod install
```

## Store paperwork this triggers

- **iOS:** the app now shows Apple's tracking prompt on first launch (only in
  builds that carry the secret). App Store Connect > App Privacy must declare
  data used for tracking (identifiers, purchases, usage data).
- **Android:** the SDK adds the `com.google.android.gms.permission.AD_ID`
  permission. Play Console > App content > Advertising ID must be answered
  "Yes", and the Data safety form updated to match.

## Verifying

TikTok Events Manager > the app > **Test event**. Run a build with the secret,
sign up and buy a tier in sandbox, and confirm `Registration` and `Subscribe`
arrive. Debug builds enable TikTok's SDK Test Event mode; release builds do not.
