# ZarchBlack Official Repository 🌌

Welcome to the official package repository for **ZarchBlack OS**, the ultimate Arch-based distribution designed for penetration testing, development, and a beautiful KDE Plasma experience.

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

## 🌟 Key Features of ZarchBlack OS
- **Customized KDE Plasma:** Deeply themed and optimized for productivity.
- **Built-in AI Assistants:** Featuring the `antigravity` package for terminal-based AI assistance.
- **Security & Hacking Tools:** Curated tools via the `zarch-hacking` meta-package.
- **Bleeding Edge Software:** Chromium-based Thorium browser, modern applets, and more.

---
*Maintained by [ZarchBlack](https://github.com/ZarchBlack).*
