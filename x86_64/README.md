# ZarchBlack Official Repository

Official package repository for the ZarchBlack Linux distribution.

## Adding the Repository

### Step 1 — Import the signing key

```bash
sudo pacman-key --add zarchblack-signing.key
sudo pacman-key --lsign-key C737412EBB361BEAA31918EE5BF604554E3F6D24
```

Or via the keyring package (recommended after first install):
```bash
sudo pacman -S zarchblack-keyring
sudo pacman-key --populate zarchblack
```

### Step 2 — Add to /etc/pacman.conf

```ini
[zarchblack-repo]
SigLevel = Required DatabaseOptional
Server = https://github.com/ZarchBlack/zarchblack-repo/releases/download/latest
```

Or for local use (during ISO build):
```ini
[zarchblack-repo]
SigLevel = Required DatabaseOptional
Server = file:///home/zarch/Folder-Build-ISO-ZarchBlack-2026/zarchblack-repo/x86_64
```

### Step 3 — Sync and install

```bash
sudo pacman -Sy
sudo pacman -S zarchblack-keyring
```

## Signature Verification

All packages and database files are signed with:
- **Key ID:** `5BF604554E3F6D24`
- **Algorithm:** RSA 4096-bit
- **Owner:** Zero7x (ZarchBlack Official Signing Key)
- **Expires:** 2 years from creation

## Maintainer

Zero7x — [github.com/ZarchBlack](https://github.com/ZarchBlack)
