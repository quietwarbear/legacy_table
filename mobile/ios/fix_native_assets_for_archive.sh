#!/bin/sh

set -eu

# Xcode archives can reuse build/native_assets/ios from a previous simulator
# run. App Store Connect rejects that because the arm64 binary is stamped as
# iOS Simulator instead of iOS. When archiving for iphoneos, replace the stale
# framework binary with the device dylib Flutter's native-assets hook just built.

case "${SDK_NAME:-}" in
  iphoneos*) ;;
  *) exit 0 ;;
esac

APP_ROOT="${FLUTTER_APPLICATION_PATH:-$(cd "${PROJECT_DIR}/.." && pwd)}"
FRAMEWORK_BIN="${APP_ROOT}/build/native_assets/ios/objective_c.framework/objective_c"
SHARED_BUILD_DIR="${APP_ROOT}/.dart_tool/hooks_runner/shared/objective_c/build"

if [ ! -f "$FRAMEWORK_BIN" ]; then
  exit 0
fi

if /usr/bin/otool -l "$FRAMEWORK_BIN" | /usr/bin/grep -q "platform 2"; then
  exit 0
fi

if ! /usr/bin/otool -l "$FRAMEWORK_BIN" | /usr/bin/grep -q "platform 7"; then
  exit 0
fi

DEVICE_DYLIB=""
if [ -d "$SHARED_BUILD_DIR" ]; then
  while IFS= read -r candidate; do
    if /usr/bin/otool -l "$candidate" | /usr/bin/grep -q "platform 2"; then
      DEVICE_DYLIB="$candidate"
      break
    fi
  done <<EOF
$(/usr/bin/find "$SHARED_BUILD_DIR" -name objective_c.dylib -type f -print)
EOF
fi

if [ -z "$DEVICE_DYLIB" ]; then
  echo "error: objective_c.framework is staged as an iOS Simulator binary, but no device objective_c.dylib was found. Run a clean iOS archive so Flutter regenerates native assets." >&2
  exit 1
fi

echo "Replacing simulator objective_c native asset with device build:"
echo "  $DEVICE_DYLIB"
/bin/cp "$DEVICE_DYLIB" "$FRAMEWORK_BIN"
