# Changelog

All notable changes to ZarchBlack will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows the `vYYYY.MM.DD` scheme.

---

## [v2026.07.07] - 2026-07-07

### Added
- `plasma6-applets-plasmusic-toolbar` v4.2.0.1 (from Chaotic-AUR) — music toolbar applet for KDE Panel
- `brave-origin` browser as the default privacy-focused browser

### Removed
- `discord` — removed from default installation
- `code` (Visual Studio Code) — removed from default installation
- `tela-circle-icon-theme-purple` — replaced by ZarchBlack custom icon theme
- `Varied-kde-arch-light` icon theme — removed as redundant
- `Varied-kde-arch-dark` icon theme — removed as redundant
- `Tela-circle-dracula-dark` icon theme — removed as redundant
- `brave-bin` — replaced by `brave-origin`

### Fixed
- **KDE Connect:** Added persistent `firewalld` rule via `firewall-offline-cmd` inside `customize_airootfs.sh` to ensure KDE Connect works immediately after installation without manual firewall configuration
- **Calamares Installer:** Fixed critical installation failure — `initcpio.conf` was targeting the `linux` kernel instead of the installed `linux-zen` kernel, causing mkinitcpio to fail at the end of every installation
- Removed orphaned `linux.preset` file from `iso/airootfs/etc/mkinitcpio.d/` that was conflicting with the Calamares mkinitcpio step

### Infrastructure
- Added professional GitHub Actions CI/CD workflows: `shellcheck.yml`, `validate-packages.yml`, `release.yml`
- Upgraded `.github/ISSUE_TEMPLATE/` from plain Markdown to structured YAML forms
- Added `PULL_REQUEST_TEMPLATE.md` for standardized contribution workflow
- Added `CODE_OF_CONDUCT.md` (Contributor Covenant)
- Rewrote `README.md` with Badges, release table, build requirements, and accurate package information
- Rewrote `CONTRIBUTING.md` with Conventional Commits guide and build instructions
- Successfully tested full installation on physical hardware ✅

---

## [v1.0] - 2026-05-30

### Added
- Initial official public release
- KDE Plasma 6 desktop running on Wayland by default (X11 fallback available)
- CachyOS & BlackArch repository integration
- Custom utilities: `zarch-hacking`, `zarchguard`, `zpackagemanager`
- ZarchBlack custom branding: GRUB theme (ZeroLayan), SDDM theme, Plymouth boot animation
- Catppuccin Mocha Lavender as default Global Theme
- Pre-installed security tools: `nmap`, `tcpdump`, `apparmor`, `firejail`
- Pre-installed productivity: `LibreOffice`, `GIMP`, `Krita`, `OBS Studio`, `VLC`
- Massive curated wallpaper collection

---

[v2026.07.07]: https://github.com/ZarchBlack/zarchblack-repo/releases/tag/v2026.07.07
[v1.0]: https://github.com/ZarchBlack/zarchblack-repo/releases/tag/v1.0
