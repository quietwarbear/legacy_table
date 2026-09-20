#!/usr/bin/env bash
#
# Upload a built .ipa to App Store Connect using an ASC API key.
#
# Uploading only places the build in App Store Connect — it does NOT submit
# for review and does NOT release to users. Submitting stays a deliberate
# human action in the App Store Connect UI.
#
# One-time setup: see scripts/release/README.md
#
# Usage:
#   scripts/release/upload_ios.sh --ipa "mobile/build/ios/ipa/Legacy Table.ipa"
#   scripts/release/upload_ios.sh --ipa path/to.ipa --validate-only
#
set -euo pipefail

IPA=""
KEY_ID="${ASC_KEY_ID:-}"
ISSUER_ID="${ASC_ISSUER_ID:-}"
VALIDATE_ONLY=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ipa)           IPA="${2:-}"; shift 2 ;;
    --key-id)        KEY_ID="${2:-}"; shift 2 ;;
    --issuer)        ISSUER_ID="${2:-}"; shift 2 ;;
    --validate-only) VALIDATE_ONLY=1; shift ;;
    -h|--help)       sed -n '2,14p' "$0"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

fail() { echo "error: $*" >&2; exit 1; }

[[ -n "$IPA" ]]       || fail "--ipa is required"
[[ -f "$IPA" ]]       || fail "IPA not found: $IPA"
[[ -n "$KEY_ID" ]]    || fail "--key-id (or ASC_KEY_ID) is required"
[[ -n "$ISSUER_ID" ]] || fail "--issuer (or ASC_ISSUER_ID) is required"

# altool discovers the key by convention; check first so the failure is legible.
KEY_PATH="$HOME/.appstoreconnect/private_keys/AuthKey_${KEY_ID}.p8"
[[ -f "$KEY_PATH" ]] || fail "API key not found at $KEY_PATH
  Download the .p8 from App Store Connect and place it there (see README)."

echo "==> Validating $(basename "$IPA")"
xcrun altool --validate-app \
  --type ios \
  --file "$IPA" \
  --apiKey "$KEY_ID" \
  --apiIssuer "$ISSUER_ID"

if [[ "$VALIDATE_ONLY" -eq 1 ]]; then
  echo "==> Validation passed (upload skipped: --validate-only)"
  exit 0
fi

echo "==> Uploading to App Store Connect"
xcrun altool --upload-app \
  --type ios \
  --file "$IPA" \
  --apiKey "$KEY_ID" \
  --apiIssuer "$ISSUER_ID"

cat <<'DONE'

==> Upload accepted.

Apple still has to process the build (usually 5-30 minutes); it appears
under TestFlight > Builds when ready. Nothing is submitted for review and
nothing reaches users until someone does that in App Store Connect.
DONE
