#!/usr/bin/env bash

# Disable CoW on /boot for BTRFS compatibility
# This prevents GRUB "premature end of file" errors

chattr +C /boot 2>/dev/null || true

# Restore vmlinuz-linux from modules directory without sparseness
# We use 'cat' instead of 'cp' because 'cp' preserves sparseness (via --sparse=auto)
# and GRUB's BTRFS driver fails to read sparse kernel files.
KVER=$(ls /usr/lib/modules/ | head -n 1)
if [ -f "/usr/lib/modules/$KVER/vmlinuz" ]; then
    rm -f /boot/vmlinuz-linux
    touch /boot/vmlinuz-linux
    chattr +C /boot/vmlinuz-linux 2>/dev/null || true
    cat "/usr/lib/modules/$KVER/vmlinuz" > /boot/vmlinuz-linux
    chmod 644 /boot/vmlinuz-linux
fi

# Recreate any microcode files so they are not sparse/compressed
for f in /boot/*-ucode.img; do
  if [ -f "$f" ]; then
    cp -a "$f" "$f.tmp"
    rm -f "$f"
    touch "$f"
    chattr +C "$f" 2>/dev/null || true
    cat "$f.tmp" > "$f"
    rm -f "$f.tmp"
  fi
done
