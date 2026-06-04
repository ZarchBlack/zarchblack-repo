# ZarchBlack Official Repository 🌌

Welcome to the official package repository and ISO build source for **ZarchBlack OS**, the ultimate Arch-based distribution designed for penetration testing, development, and a beautiful KDE Plasma experience.

<p align="center">
  <img src="https://raw.githubusercontent.com/ZarchBlack/zarchblack-iso/main/screenshot.png" alt="ZarchBlack Desktop" width="800">
</p>

## 🚀 Download ZarchBlack OS
Get the latest live ISO image to install or test ZarchBlack.

[![Download ISO from Hugging Face](https://img.shields.io/badge/Download_ISO-Hugging_Face-FFD21E?style=for-the-badge&logo=huggingface&logoColor=000)](https://huggingface.co/datasets/zarchblack/zarchblack-releases/tree/main)

---

## 📦 How to Add This Repository to Any Arch System
If you are already running Arch Linux or any Arch-based distro, you can install ZarchBlack's exclusive packages (like `antigravity`, `zarchguard`, `zpackagemanager`, `zarch-hacking`, and custom icons/themes) by adding this repository to your system.

### 1. Edit your `pacman.conf`
Open `/etc/pacman.conf` with root privileges:
```bash
sudo nano /etc/pacman.conf
```

### 2. Append the ZarchBlack Repo
Scroll to the bottom of the file and add the following lines:

```ini
[zarchblack-repo]
SigLevel = Optional TrustAll
Server = https://zarchblack.github.io/zarchblack-repo/$arch
```

### 3. Sync and Install
Update your databases and install any package:
```bash
sudo pacman -Sy
sudo pacman -S zarchblack-hacking antigravity
```

---

## 🛠️ For Developers & Contributors

### Overview
ZarchBlack is a custom Arch Linux live ISO featuring:
- **Base:** Arch Linux (rolling release)
- **Desktop:** KDE Plasma 6 on Wayland (X11 fallback available)
- **Installer:** Calamares graphical installer
- **Theming:** Darkly/Catppuccin Mocha Lavender theme with Layan decorations
- **Security:** Firewalld, UFW, Firejail preconfigured

### Project Structure
```text
zarchblack_iso/
├── iso/                  # archiso profile (ISO build configuration)
├── packages/             # PKGBUILD sources for custom packages
├── branding/             # Calamares, GRUB, SDDM, Plymouth themes
├── configs/              # KDE, GTK, shell, system configuration files
├── plasma/               # Plasma themes, color schemes, Kvantum
├── themes/               # Icon themes, cursors
├── scripts/              # Build and maintenance scripts
└── releases/             # ISO release assets
```

### Building the ISO Locally
```bash
git clone https://github.com/ZarchBlack/zarchblack-repo.git
cd zarchblack-repo
sudo mkarchiso -v -w ./work -o ./out ./iso
```

### Custom Packages
- `zarchguard` - Security hardening
- `zarch-hacking` - Security tools manager
- `zpackagemanager` - Package management utility
- `zarchblack-theme` - Complete desktop theme
- `zarchblack-wallpapers` - Wallpaper collection
- `zarchblack-branding` - OS identity files

## License
This project is licensed under GPLv3.

---
*Maintained by [ZarchBlack](https://github.com/ZarchBlack).*
