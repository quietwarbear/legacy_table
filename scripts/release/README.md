# Release upload tooling

Command-line uploads to the App Store and Google Play, so shipping a build
doesn't require a console session. Both scripts are app-agnostic — they take
an artifact path and a package/bundle id, so Kindred and Ile Ubuntu can use
them too.

**Neither script releases anything to users by itself.** The iOS script
uploads a build to App Store Connect (submitting for review stays a human
action). The Android script defaults to creating a *draft* release (rollout
stays a human action) unless you pass `--status completed`.

## One-time setup

### App Store Connect API key (iOS)

1. App Store Connect → **Users and Access** → **Integrations** → **App Store Connect API**
2. Generate an API key with the **App Manager** role
3. Download the `.p8` — Apple lets you download it exactly once
4. Put it where `altool` looks for it, named by key id:

   ```bash
   mkdir -p ~/.appstoreconnect/private_keys
   mv ~/Downloads/AuthKey_ABC123XYZ.p8 ~/.appstoreconnect/private_keys/
   chmod 600 ~/.appstoreconnect/private_keys/AuthKey_ABC123XYZ.p8
   ```

5. Note the **Key ID** and the **Issuer ID** (shown above the key list), and
   put them in your shell profile:

   ```bash
   export ASC_KEY_ID=ABC123XYZ
   export ASC_ISSUER_ID=aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
   ```

### Play service account (Android)

1. Play Console → **Setup** → **API access** → link or create a Google Cloud
   project, then create a **service account**
2. In Google Cloud, give that service account a **JSON key** and download it
3. Back in Play Console → **Users and permissions** → invite the service
   account's email, granting **Release to production** (plus the tracks you
   use) for the app
4. Store the JSON outside the repo and point the scripts at it:

   ```bash
   export GOOGLE_PLAY_SERVICE_ACCOUNT_JSON="$HOME/.config/play/legacy-table-publisher.json"
   chmod 600 "$GOOGLE_PLAY_SERVICE_ACCOUNT_JSON"
   ```

Python dependencies for the Android script:

```bash
pip3 install google-api-python-client google-auth
```

> Keep both credentials out of git. They are account-level secrets: the ASC
> key can upload builds for the whole team, and the service account can ship
> to production.

## Building

```bash
cd mobile
flutter build appbundle --release --dart-define=PROD=true   # -> build/app/outputs/bundle/release/app-release.aab
flutter build ipa       --release --dart-define=PROD=true   # -> build/ios/ipa/*.ipa
```

Version and build number come from `version:` in `mobile/pubspec.yaml`
(e.g. `2.3.7+263` → version 2.3.7, build 263). Bump it before building;
Play rejects a versionCode that isn't higher than the live one.

## Uploading

```bash
# iOS — validate first if you want a dry run
scripts/release/upload_ios.sh --ipa "mobile/build/ios/ipa/Legacy Table.ipa" --validate-only
scripts/release/upload_ios.sh --ipa "mobile/build/ios/ipa/Legacy Table.ipa"

# Android — draft by default
scripts/release/upload_android.py \
    --aab mobile/build/app/outputs/bundle/release/app-release.aab \
    --track production \
    --notes "Performance and reliability improvements."
```

For the Capacitor apps, pass their ids explicitly:

```bash
scripts/release/upload_android.py --package com.ubuntumarket.kindred   --aab ... --track production
scripts/release/upload_android.py --package com.ubuntumarket.ileubuntu --aab ... --track production
```

## After uploading

- **iOS**: the build processes for 5–30 minutes, then appears under
  TestFlight → Builds. Attach it to a version and submit for review in App
  Store Connect.
- **Android**: a draft release waits in the chosen track. Review it in Play
  Console and start the rollout.
