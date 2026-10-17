# Sentry debug-symbol upload

Native crashes (SIGABRT, watchdog terminations) and, if we ever obfuscate,
Dart stack traces arrive in Sentry as `<unknown>` frames unless debug
symbols are uploaded. `sentry_dart_plugin` does that upload.

Configured in `pubspec.yaml` (the `sentry:` block). It runs as a **separate
command after the build** — it never runs during `flutter build`, so it
cannot break a release build.

## One-time setup
Create a Sentry **internal integration** or **auth token** with
`project:releases` + `project:write` scope (Sentry → Settings → Auth
Tokens). Keep it out of git; pass it via the environment.

## Per release — Android
```bash
# 1. Build (optionally add --obfuscate --split-debug-info=build/symbols;
#    if you obfuscate, this upload becomes REQUIRED to read Dart stacks).
flutter build appbundle --release

# 2. Upload symbols.
SENTRY_AUTH_TOKEN=<token> dart run sentry_dart_plugin
```

## Per release — iOS
```bash
flutter build ipa --release
SENTRY_AUTH_TOKEN=<token> dart run sentry_dart_plugin
```
This uploads the iOS dSYMs, so iOS native issues (watchdog, hangs)
symbolicate.

## Scope / honest limits
- **iOS dSYMs**: reliably uploaded → iOS native frames symbolicate.
- **Dart**: covered (matters only if we start obfuscating).
- **Android native**: the app's own native code symbolicates. Frames that
  live inside the **prebuilt Flutter engine or a third-party SDK**
  (e.g. the TikTok SDK's native libs — the suspected source of
  LEGACY-TABLE-MOBILE-9) may still not fully resolve without those
  libraries' own symbols. If the SIGABRT stays opaque after this, the next
  lever is the Sentry Android Gradle plugin (`io.sentry.android.gradle`,
  `uploadNativeSymbols = true`) — deliberately not added here to keep the
  release build un-touched.
