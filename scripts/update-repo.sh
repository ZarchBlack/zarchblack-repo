#!/usr/bin/env bash
# ===================================================================
# ZarchBlack Local Repository Update Script
# Updates the pacman repository database from built packages
# ===================================================================
set -euo pipefail

REPO_NAME="zarchblack-local"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"
PKGS_DIR="${PROJECT_DIR}/local-repo/packages"
DB_DIR="${PROJECT_DIR}/local-repo/db"

cd "${PROJECT_DIR}"

echo "=== ZarchBlack Repository Update ==="
echo "Repository: ${REPO_NAME}"
echo "Packages:   ${PKGS_DIR}"
echo "Database:   ${DB_DIR}"

# Ensure directories exist
mkdir -p "${PKGS_DIR}" "${DB_DIR}"

# Count packages
PKG_COUNT=$(ls "${PKGS_DIR}"/*.pkg.tar.zst 2>/dev/null | wc -l)
echo "Found ${PKG_COUNT} packages"

if [[ ${PKG_COUNT} -eq 0 ]]; then
  echo "No packages found. Nothing to update."
  exit 0
fi

# Update repository database
echo "Updating repository database..."
cd "${DB_DIR}"
repo-add --sign "${REPO_NAME}.db.tar.gz" "${PKGS_DIR}"/*.pkg.tar.zst

echo "=== Repository Update Complete ==="
echo ""
echo "IMPORTANT: Update pacman.conf to point to:"
echo "  Server = file://${PROJECT_DIR}/local-repo/packages"
echo ""
echo "Or use the relative path in your build pacman.conf:"
echo "  Server = file:///path/to/zarchblack_iso/local-repo/packages"
