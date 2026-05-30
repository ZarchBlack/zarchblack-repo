# ZarchBlack

A personal Arch Linux-based distribution with KDE Plasma and Wayland.

## Overview

ZarchBlack is a custom Arch Linux live ISO featuring:

- **Base:** Arch Linux (rolling release)
- **Desktop:** KDE Plasma 6 on Wayland (X11 fallback available)
- **Installer:** Calamares graphical installer
- **Theming:** Darkly/Catppuccin Mocha Lavender theme with Layan decorations
- **Security:** Firewalld, UFW, Firejail preconfigured
- **Packages:** Curated set of development, multimedia, and system utilities

## Project Structure

```
zarchblack_iso/
├── kde-releng/           # archiso profile (ISO build configuration)
├── local-repo/           # Local pacman repository
│   ├── packages/         # Built .pkg.tar.zst files
│   ├── db/               # Repository database files
│   └── staging/          # Staging area for new packages
├── packages/             # PKGBUILD sources for custom packages
├── branding/             # Calamares, GRUB, SDDM, Plymouth themes
├── configs/              # KDE, GTK, shell, system configuration files
├── plasma/               # Plasma themes, color schemes, Kvantum
├── themes/               # Icon themes, cursors
├── wallpapers/           # Wallpaper collection
├── scripts/              # Build and maintenance scripts
├── tools/                # Python utilities
├── releases/             # ISO release assets
├── docs/                 # Documentation
└── screenshots/          # Distribution screenshots
```

## Building the ISO

```bash
cd zarchblack_iso
sudo mkarchiso -v -w ./work -o ./out ./kde-releng
```

## Local Repository

Custom packages are served from a local pacman repository:

```ini
[zarchblack-local]
SigLevel = Optional TrustAll
Server = file:///path/to/zarchblack_iso/local-repo/packages
```

Update the database after adding packages:

```bash
./local-repo/update-repo.sh
```

## Custom Packages

- `zarchguard` - Security hardening
- `zarch-hacking` - Security tools manager
- `zpackagemanager` - Package management utility
- `zarchblack-theme` - Complete desktop theme
- `zarchblack-wallpapers` - Wallpaper collection
- `zarchblack-branding` - OS identity files
- `zarchblack-plasma-config` - Plasma desktop defaults
- `zarchblack-kde-settings` - KDE settings defaults
- `zarchblack-icons` - Icon themes
- `zarchblack-sddm-theme` - SDDM login theme
- `zarchblack-plymouth` - Boot splash
- `zarchblack-neofetch` - System info display
- `zarchblack-system-config` - System configuration

## License

This project is licensed under GPLv3.

## Repository

**Private** — [https://github.com/ZarchBlack](https://github.com/ZarchBlack)
