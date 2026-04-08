#!/bin/sh

# ci_post_clone.sh — Xcode Cloud post-clone script for Flutter iOS builds
# This script runs after Xcode Cloud clones the repository.
# It installs Flutter SDK, resolves dependencies, and runs pod install.

set -e

echo "=== Legacy Table: Xcode Cloud ci_post_clone.sh ==="
echo "Current directory: $(pwd)"
echo "Repository root: $CI_PRIMARY_REPOSITORY_PATH"

# -------------------------------------------------------
# 1. Install Flutter SDK
# -------------------------------------------------------
# Use the stable channel. Pin to a specific version if needed.
FLUTTER_VERSION="3.29.3"
echo ">>> Installing Flutter SDK $FLUTTER_VERSION..."

git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$HOME/flutter"
export PATH="$HOME/flutter/bin:$PATH"

echo ">>> Flutter version:"
flutter --version

# Pre-cache iOS artifacts
flutter precache --ios

# -------------------------------------------------------
# 2. Navigate to the Flutter project (mobile directory)
# -------------------------------------------------------
cd "$CI_PRIMARY_REPOSITORY_PATH/mobile"
echo ">>> Working directory: $(pwd)"

# -------------------------------------------------------
# 3. Resolve Flutter dependencies
# -------------------------------------------------------
echo ">>> Running flutter pub get..."
flutter pub get

# -------------------------------------------------------
# 4. Generate iOS build files
# -------------------------------------------------------
echo ">>> Generating iOS build files..."
flutter build ios --config-only --release --no-codesign

# -------------------------------------------------------
# 5. Install CocoaPods dependencies
# -------------------------------------------------------
echo ">>> Installing CocoaPods dependencies..."
cd ios
pod install

echo "=== ci_post_clone.sh completed successfully ==="
