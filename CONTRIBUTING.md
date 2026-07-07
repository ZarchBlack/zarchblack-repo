# Contributing to ZarchBlack

Thank you for your interest in ZarchBlack! This guide will help you contribute effectively to the project.

---

## 📋 Conventional Commits

All commits **must** follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <description>
```

### Types
| Type | When to use |
|---|---|
| `feat` | Adding a new package, feature, or utility |
| `fix` | Fixing a bug in scripts, configs, or package lists |
| `chore` | Maintenance tasks, dependency updates |
| `docs` | Changes to documentation only |
| `remove` | Removing a package from the distribution |
| `refactor` | Restructuring code without changing behavior |
| `style` | Formatting, whitespace changes |
| `ci` | Changes to CI/CD workflows |

### Examples
```bash
feat(packages): add plasma6-applets-plasmusic-toolbar v4.2.0.1
fix(calamares): use linux-zen kernel in initcpio.conf
remove(packages): drop discord and code from default install
docs(readme): add build requirements table
ci(workflows): add shellcheck workflow for script validation
```

---

## 🔄 Package Addition / Removal Process

### Adding a Package
1. Add the package name to `iso/packages.x86_64` in the correct category section
2. If it's a custom package, create a proper PKGBUILD under `packages/<package-name>/`
3. Test in a clean build: `sudo ./scripts/build-iso.sh clean`
4. Test installation on a VM or physical hardware
5. Update `CHANGELOG.md` under `[Unreleased]`
6. Submit PR using the PR template

### Removing a Package
1. Remove the package name from `iso/packages.x86_64`
2. If there are leftover configs in `iso/airootfs/`, remove them too
3. Test that the ISO still builds and installs cleanly
4. Update `CHANGELOG.md`

---

## 🏗️ ISO Build Process

### Requirements
- Arch Linux (native or VM)
- `archiso` package installed
- At least 8 GB RAM and 30 GB free disk space

### Clean Build
```bash
# Navigate to the ISO profile directory
cd /path/to/zarchblack_iso

# Remove old build artifacts
sudo rm -rf out/* work/

# Start a fresh build
sudo ./scripts/build-iso.sh clean
```

### Testing
Always test the built ISO on:
- [ ] A virtual machine (VirtualBox, QEMU/KVM, or VMware)
- [ ] Physical hardware (preferred)

Verify that:
- [ ] The live session boots correctly
- [ ] The Calamares installer completes without errors
- [ ] The installed system boots and KDE Plasma loads
- [ ] System updates work (`sudo pacman -Syu`)
- [ ] KDE Connect is functional (firewall rules are active)

---

## 🐛 Reporting Bugs

Use the [Bug Report template](.github/ISSUE_TEMPLATE/bug_report.yml) to report issues. Please include:
- The exact ISO version
- Whether you tested on physical hardware or a VM
- Steps to reproduce the problem
- Any relevant logs

---

## 🌿 Branch Naming

```
feat/add-package-name
fix/calamares-initcpio
docs/update-readme
remove/discord-package
```

---

## 🔒 Security Issues

Do **not** open a public issue for security vulnerabilities. Instead, follow the instructions in [SECURITY.md](SECURITY.md) to report privately.
