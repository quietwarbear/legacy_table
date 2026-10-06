#!/bin/sh

# ci_post_clone.sh
#
# Xcode Cloud runs this script after cloning the repo and before any build
# step. It exists because Xcode Cloud has no native Flutter support: it'll
# happily try to build mobile/ios/Runner.xcworkspace, but the build fails
# without two preparatory steps that are normally implicit on a dev's Mac:
#
#   1. `flutter pub get` generates mobile/ios/Flutter/Generated.xcconfig,
#      which Release.xcconfig and Debug.xcconfig both `#include`. Without
#      it the xcconfig parse errors out:
#          mobile/ios/Flutter/Release.xcconfig:2
#              could not find included file 'Generated.xcconfig' in search paths
#
#   2. `pod install` generates the Pods workspace and the
#      Pods-Runner-*-output-files.xcfilelist files that Xcode's Run Script
#      build phases reference. Without it Xcode errors out:
#          Unable to load contents of file list:
#              '/Target Support Files/Pods-Runner/Pods-Runner-resources-Release-output-files.xcfilelist'
#          (same for frameworks-Release-input-files / output-files)
#
# Symptoms before this script: every push to main lights up Xcode Cloud's
# "family_recipe_app | Default | Archive - iOS" check with 5 errors / 4
# warnings, blocking the green status on main and breaking TestFlight
# autoupload. This script makes the iOS build self-sufficient on CI.

set -e
set -o pipefail

echo "──── Xcode Cloud :: ci_post_clone.sh ────"
echo "    CI_WORKSPACE = ${CI_WORKSPACE:-unset}"
echo "    CI_PRIMARY_REPOSITORY_PATH = ${CI_PRIMARY_REPOSITORY_PATH:-unset}"
echo "    pwd = $(pwd)"

# Xcode Cloud sets CI_WORKSPACE to the repo root. Be defensive in case it's
# not set (e.g. someone runs this locally for debugging).
REPO_ROOT="${CI_PRIMARY_REPOSITORY_PATH:-${CI_WORKSPACE:-$(cd "$(dirname "$0")/../../.." && pwd)}}"
MOBILE_DIR="${REPO_ROOT}/mobile"
IOS_DIR="${MOBILE_DIR}/ios"

echo ""
echo "──── 1/3 Install Flutter (via Homebrew, cached after first run) ────"
# Homebrew is preinstalled on Xcode Cloud images. The --cask installs the
# Flutter SDK and puts the `flutter` binary on PATH.
if command -v flutter >/dev/null 2>&1; then
    echo "    flutter already on PATH: $(command -v flutter)"
else
    brew install --cask flutter
fi

# Make sure the flutter we just installed is reachable for the rest of this
# script even if PATH wasn't refreshed mid-shell.
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

flutter --version
flutter doctor -v || true

# This project is CocoaPods-based. Newer Flutter releases may enable Swift
# Package Manager integration automatically and try to add posthog-ios while
# Xcode Cloud has automatic package resolution disabled. That combination
# fails before the archive starts because there is no SPM Package.resolved.
# Keep CI on the dependency manager committed by this project for this
# release; an SPM migration should be handled separately and atomically.
flutter config --no-enable-swift-package-manager

echo ""
echo "──── 2/3 flutter pub get (regenerates Generated.xcconfig) ────"
cd "$MOBILE_DIR"
flutter pub get

# Optional: TikTok App Events. Xcode Cloud builds with xcodebuild, which never
# sees `flutter build --dart-define` flags, so bake the define into
# Generated.xcconfig here. Set TIKTOK_APP_SECRET_IOS as a *secret* environment
# variable on the Xcode Cloud workflow; when it is unset this block is skipped
# and the TikTok SDK stays disabled in the build.
if [ -n "${TIKTOK_APP_SECRET_IOS:-}" ]; then
    echo ""
    echo "──── 2b flutter build ios --config-only (TikTok dart-define) ────"
    flutter build ios --config-only --release --no-codesign \
        --dart-define=TIKTOK_APP_SECRET_IOS="${TIKTOK_APP_SECRET_IOS}"
fi

echo ""
echo "──── 3/3 pod install (regenerates Pods workspace + xcfilelists) ────"
cd "$IOS_DIR"
# `pod install` reads ../pubspec.yaml indirectly via Flutter's podhelper.rb,
# which only works after `flutter pub get` has run — that's why the steps
# are in this order.
pod install --repo-update

echo ""
echo "✅ ci_post_clone.sh complete — Xcode build can now proceed."
