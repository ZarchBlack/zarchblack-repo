#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════
#  ZarchBlack Repository Update Script
#  Builds, signs, and publishes packages to the local repo
#
#  Usage:
#    ./update-repo.sh                    # Update existing packages
#    ./update-repo.sh /path/to/PKGBUILD  # Build and add a specific package
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

# ── Configuration ─────────────────────────────────────────────
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_NAME=$(ls "$REPO_DIR"/*.db.tar.gz 2>/dev/null | head -1 | xargs -I{} basename {} .db.tar.gz)
SIGNING_KEY=$(grep "^GPGKEY=" /etc/makepkg.conf | cut -d'"' -f2)
LOCKFILE="/tmp/zarchblack-repo.lock"

# ── Colors ────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

info()  { echo -e "${CYAN}[..] $*${NC}"; }
ok()    { echo -e "${GREEN}[OK] $*${NC}"; }
warn()  { echo -e "${YELLOW}[!!] $*${NC}"; }
fail()  { echo -e "${RED}[XX] $*${NC}"; exit 1; }

# ── Sanity checks ─────────────────────────────────────────────
[[ -z "$DB_NAME" ]]       && fail "No database found in $REPO_DIR"
[[ -z "$SIGNING_KEY" ]]   && fail "GPGKEY not set in /etc/makepkg.conf"
[[ -f "$LOCKFILE" ]]      && fail "Lock file exists: another instance is running. Remove $LOCKFILE if stale."

trap "rm -f $LOCKFILE" EXIT
touch "$LOCKFILE"

echo -e "${BOLD}ZarchBlack Repository Updater${NC}"
echo "  Repo dir  : $REPO_DIR"
echo "  DB name   : $DB_NAME"
echo "  Signing   : $SIGNING_KEY"
echo ""

# ── Mode: Build specific PKGBUILD ────────────────────────────
if [[ -n "${1:-}" ]]; then
  PKGBUILD_PATH="$1"
  [[ -f "$PKGBUILD_PATH" ]] || fail "PKGBUILD not found: $PKGBUILD_PATH"

  BUILD_DIR=$(dirname "$PKGBUILD_PATH")
  info "Building package from $BUILD_DIR ..."

  cd "$BUILD_DIR"
  makepkg -sf --sign --key "$SIGNING_KEY" --noconfirm 2>&1 || fail "makepkg failed"

  # Move built package to repo dir
  NEW_PKGS=$(ls ./*.pkg.tar.zst 2>/dev/null) || fail "No .pkg.tar.zst produced"
  for pkg in $NEW_PKGS; do
    # Verify .sig was created
    [[ -f "${pkg}.sig" ]] || fail "Missing signature for $pkg"
    cp "$pkg" "${pkg}.sig" "$REPO_DIR/"
    ok "Added: $(basename $pkg)"
  done
fi

# ── Update database ───────────────────────────────────────────
cd "$REPO_DIR"
info "Scanning for unsigned packages..."

UNSIGNED=0
for pkg in *.pkg.tar.zst; do
  [[ -f "$pkg" ]] || continue
  if [[ ! -f "${pkg}.sig" ]]; then
    warn "Unsigned package found: $pkg — signing now..."
    gpg --detach-sign --no-armor --default-key "$SIGNING_KEY" "$pkg"
    ok "Signed: $pkg"
    ((UNSIGNED++)) || true
  fi
done
[[ $UNSIGNED -eq 0 ]] && ok "All packages are signed"

info "Rebuilding repository database (signed)..."
repo-add --sign --key "$SIGNING_KEY" --remove \
  "${DB_NAME}.db.tar.gz" \
  *.pkg.tar.zst 2>&1

# ── Verify signatures ─────────────────────────────────────────
info "Verifying all signatures..."
ERRORS=0
for pkg in *.pkg.tar.zst; do
  [[ -f "$pkg" ]] || continue
  if gpg --verify "${pkg}.sig" "$pkg" 2>/dev/null; then
    ok "✓ $pkg"
  else
    warn "✗ Signature INVALID: $pkg"
    ((ERRORS++)) || true
  fi
done

# Verify database signatures
for sig in "${DB_NAME}.db.tar.gz.sig" "${DB_NAME}.files.tar.gz.sig"; do
  [[ -f "$sig" ]] || fail "Missing database signature: $sig"
  ok "✓ $sig"
done

[[ $ERRORS -gt 0 ]] && fail "$ERRORS package(s) have invalid signatures"

# ── Summary ───────────────────────────────────────────────────
echo ""
ok "Repository update complete"
echo "  Packages : $(ls *.pkg.tar.zst 2>/dev/null | wc -l)"
echo "  Signatures: $(ls *.pkg.tar.zst.sig 2>/dev/null | wc -l)"
echo "  DB signed : $(ls *.db.tar.gz.sig 2>/dev/null | wc -l) file(s)"
