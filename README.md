# ZarchBlack Official Repository 🌌

<p align="center">
  <img src="screenshots/zheader.svg" alt="ZarchBlack Banner" width="100%" />
</p>

<p align="center">
  <a href="https://huggingface.co/datasets/zarchblack/zarchblack-releases/tree/main"><img src="https://img.shields.io/badge/Download_ISO-Hugging_Face-FFD21E?style=for-the-badge&logo=huggingface&logoColor=000" alt="Download ISO" /></a>
  <a href="https://github.com/ZarchBlack"><img src="https://img.shields.io/badge/GitHub-Repository-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub" /></a>
  <a href="https://github.com/ZarchBlack"><img src="https://img.shields.io/badge/Discord-Community-5865F2?style=for-the-badge&logo=discord&logoColor=white" alt="Discord" /></a>
  <a href="https://github.com/ZarchBlack"><img src="https://img.shields.io/badge/Telegram-Channel-26A5E4?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram" /></a>
</p>

---

## 🌟 About ZarchBlack

**ZarchBlack** is a modern, cutting-edge Linux distribution based on **Arch Linux**, engineered specifically for developers, programmers, cybersecurity specialists, ethical hackers, system administrators, and advanced Linux enthusiasts.

More than just a standard Arch Linux spin, ZarchBlack delivers a fully optimized, secure, and visually stunning operating system. It comes equipped with a custom-crafted **KDE Plasma 6** desktop environment running natively on **Wayland** (released in 2026) that strikes a perfect balance between power, beauty, and security.

### 🖼️ Preview ZarchBlack
<p align="center">
  <img src="screenshot.png" alt="ZarchBlack Desktop Preview" width="100%" />
</p>

---

## 🎨 The Passion & Story Behind ZarchBlack

ZarchBlack is developed and maintained by **Zero7x**, a passionate Moroccan developer. Zero7x did not formally study programming or software development; instead, this distribution is the product of pure self-learning, curiosity, and a deep-seated passion for Linux—especially Arch Linux.

Building ZarchBlack required months of intense, daily effort, troubleshooting countless compilation errors, refining configurations, and repeatedly rebuilding the ISO to get everything perfect. Zero7x drew inspiration from the most popular Linux distributions, combining their finest ideas and features into a single, cohesive operating system. Every detail, from the massive, high-quality, hand-selected wallpaper collection to the stunning themes and icons, was crafted with care to offer a desktop experience never seen in any other 2026 distribution.

Rather than just testing on virtual machines, ZarchBlack was rigorously tested and verified directly on **physical hardware and real storage drives** to guarantee maximum performance, stability, and reliability on bare metal.

---

## 🛠️ Specialized Custom Utilities

ZarchBlack features three unique, built-in applications designed to simplify package management, system maintenance, and security workflows:

### 1. `zarch-hacking` 🥷
* **BlackArch Integration:** Instant access to the massive BlackArch security repository containing over 2000+ security and penetration testing tools.
* **Categorized Security Tools:** Easily search and install security software grouped logically by field (Reconnaissance, Web Apps, Wireless, Forensic, Exploitation, etc.).
* **Isolated Testing:** Sandbox testing environments to evaluate programs securely without altering your host system.

<p align="center">
  <img src="screenshots/terminal.svg" alt="zarch-hacking CLI Preview" width="100%" />
</p>

### 2. `zarchguard` 🛡️
* **Smart System Updates:** Perform safe rolling-release updates with automated pre-checks.
* **Deep Clean:** Clean pacman package cache, system logs, old configurations, and orphaned files to keep your system fast and lean.
* **Maintenance & Repair:** Automated diagnostics, troubleshooting tools, and quick bug-fixing scripts to repair system and theme configurations.

### 3. `zpackagemanager` 📦
* **Intuitive Package Management:** A powerful command-line interface to install, remove, and manage packages.
* **Repository Control:** Seamlessly enable, disable, and configure official and custom repositories.
* **Dependency Resolver:** Smoothly handles complex AUR and custom repository package dependencies.

---

## 🚀 Key Features

* **Native Wayland Desktop:** Runs the modern KDE Plasma 6 desktop environment on Wayland by default (with X11 fallback available).
* **Power & Performance:** Integrates the complete set of **Cachyos** repositories, featuring CPU-optimized kernels, performance tweaks, and improved responsiveness.
* **Security Out of the Box:** Pre-configured firewalls (`firewalld`, `ufw`) and application sandboxing (`firejail`).
* **Stunning Visuals:** Sleek dark-mode styling utilizing the **Darkly** theme, **Layan** window decorations, **Catppuccin Mocha Lavender** color schemes, and beautiful custom icons.
* **Massive Wallpaper Collection:** Hundreds of carefully curated, beautiful wallpapers matching every taste.

---

## 📦 How to Add This Repository to Any Arch System

If you are already running Arch Linux or any Arch-based distribution, you can install ZarchBlack's exclusive packages by adding our repository to your system.

### 1. Edit your `pacman.conf`
Open `/etc/pacman.conf` with root privileges:
```bash
sudo nano /etc/pacman.conf
```

### 2. Append the ZarchBlack Repo
Scroll to the bottom of the file and add the following lines:
```ini
[zarchblack-repo]
SigLevel = Required DatabaseOptional
Server = https://github.com/ZarchBlack/zarchblack-repo/releases/download/repo
```

### 3. Sync and Install
Update your database index and install any of our custom utilities:
```bash
sudo pacman -Sy
sudo pacman -S zarch-hacking zarchguard zpackagemanager
```

---

## 🛠️ For Developers & Contributors

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
To compile the ISO locally from source, run:
```bash
git clone https://github.com/ZarchBlack/zarchblack-repo.git
cd zarchblack-repo
sudo ./scripts/build-iso.sh clean
```

---

## 📅 Releases & Versioning

### **v1.0 (Rolling Release)**
* **Release Date:** May 30, 2026
* **Notes:** Initial official public release. Includes pre-configured KDE Plasma 6 Wayland desktop, Cachyos & BlackArch repository integration, and the official release of `zarch-hacking`, `zarchguard`, and `zpackagemanager`.

---

## 🌐 Community & Support
* **GitHub Repository:** [ZarchBlack GitHub](https://github.com/ZarchBlack)
* **Discord Server:** [Join our Discord](https://github.com/ZarchBlack)
* **Telegram Channel:** [Join our Telegram](https://github.com/ZarchBlack)
* **Documentation Wiki:** [Read the Wiki](https://github.com/ZarchBlack)

---
*ZarchBlack is licensed under the GPLv3 License. Maintained with passion by **Zero7x** and the open-source community.*
