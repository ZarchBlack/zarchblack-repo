#!/usr/bin/env bash
# ===================================================================
# ZarchBlack ISO Build Script
# Usage: ./scripts/build-iso.sh [clean]
# ===================================================================
set -euo pipefail

ISO_PROFILE="iso"
WORK_DIR="./work"
OUT_DIR="./out"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"

cd "${PROJECT_DIR}"

echo "=== ZarchBlack ISO Build ==="
echo "Profile: ${ISO_PROFILE}"
echo "Date:    $(date '+%Y-%m-%d %H:%M:%S')"

# Check for root
if [[ $EUID -ne 0 ]]; then
  echo "ERROR: This script must be run as root (for mkarchiso)"
  exit 1
fi


# Clean build if requested
if [[ "${1:-}" == "clean" ]]; then
  echo "Cleaning previous build artifacts..."
  rm -rf "${WORK_DIR}" "${OUT_DIR}"
  echo "Clean complete."
fi

# Create output directory
mkdir -p "${OUT_DIR}"

# Build ISO
echo "Starting ISO build..."
mkarchiso -v -w "${WORK_DIR}" -o "${OUT_DIR}" "${ISO_PROFILE}"

echo "=== Build Complete ==="
echo "ISO: ${OUT_DIR}/ZarchBlack-*.iso"
ls -lh "${OUT_DIR}"/ZarchBlack-*.iso 2>/dev/null || echo "No ISO found (build may have failed)"
