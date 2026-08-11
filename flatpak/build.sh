#!/usr/bin/env bash
set -euo pipefail

# Builds Karter as a Flatpak using the manifest in this directory.
#
# Requirements:
#   - flatpak, flatpak-builder
#   - Flathub remote for the freedesktop runtime/sdk
#
# Example:
#   ./flatpak/build.sh
#
# The result is exported to ./flatpak/repo and installable with:
#   flatpak --user install ./flatpak/repo dev.abrah.karter

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
MANIFEST="$SCRIPT_DIR/dev.abrah.karter.yml"
BUILD_DIR="$SCRIPT_DIR/build"
REPO_DIR="$SCRIPT_DIR/repo"

echo "Installing flatpak runtimes (if missing)..."
flatpak --user install -y --noninteractive \
  org.freedesktop.Sdk//25.08 \
  org.freedesktop.Platform//25.08 \
  org.freedesktop.Sdk.Extension.llvm22//25.08 >/dev/null 2>&1 || true

echo "Building with flatpak-builder..."
flatpak-builder \
  --user \
  --repo="$REPO_DIR" \
  --force-clean \
  --install-deps-from=flathub \
  "$BUILD_DIR" "$MANIFEST" 2>&1 | tee "$SCRIPT_DIR/build.log"

if ! grep -qi "Exported" "$SCRIPT_DIR/build.log" && [[ ! -d "$BUILD_DIR/files" ]]; then
  echo "Build failed — see $SCRIPT_DIR/build.log"
  exit 1
fi

echo "Exporting to local repo..."
flatpak build-export "$REPO_DIR" "$BUILD_DIR"

echo "Done. Install with:"
echo "  flatpak --user install $REPO_DIR dev.abrah.karter"
