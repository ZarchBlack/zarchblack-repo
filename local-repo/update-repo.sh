#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="zarchblack-local"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_TARGET="${REPO_DIR}/repo"

echo "=== ZarchBlack Repository Update ==="
echo "Repository: ${REPO_NAME}"
echo "Target:     ${REPO_TARGET}"

mkdir -p "${REPO_TARGET}"

PKG_COUNT=$(ls "${REPO_TARGET}"/*.pkg.tar.zst 2>/dev/null | wc -l)
echo "Found ${PKG_COUNT} packages"

if [[ ${PKG_COUNT} -eq 0 ]]; then
  echo "No packages to add to database."
fi

cd "${REPO_TARGET}"
repo-add "${REPO_NAME}.db.tar.gz" *.pkg.tar.zst 2>/dev/null || true

echo ""
echo "=== Update Complete ==="
echo "Add to pacman.conf:"
echo "  [${REPO_NAME}]"
echo "  SigLevel = Optional TrustAll"
echo "  Server = file://${REPO_TARGET}"
