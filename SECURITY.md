# Security Policy

## Supported Versions

ZarchBlack is a rolling-release distribution. Only the latest ISO and packages are actively supported.

| Version | Supported |
|---|---|
| Latest release (`v2026.07.07` and newer) | ✅ Yes |
| Older releases | ❌ No — please update |

---

## Reporting a Vulnerability

**Do NOT open a public GitHub issue for security vulnerabilities.**

If you discover a security vulnerability in ZarchBlack (including the ISO build system, custom packages, or bundled configurations), please report it privately:

### Private Disclosure Process

1. **Email:** Send a detailed report to the project maintainer via GitHub's [private security advisory](https://github.com/ZarchBlack/zarchblack-repo/security/advisories/new) feature.

2. **Include in your report:**
   - A clear description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact and affected components
   - Your suggested fix (if any)

3. **Response timeline:**
   - **Acknowledgment:** Within 48 hours
   - **Assessment:** Within 7 days
   - **Fix & disclosure:** As soon as a fix is available

---

## Security Features in ZarchBlack

ZarchBlack is built with security in mind and ships with the following protections enabled by default:

- **`firewalld`** — Pre-configured firewall with strict default rules
- **`firejail`** — Application sandboxing for browsers and sensitive apps
- **`apparmor`** — Mandatory access control framework
- **`audit`** — System auditing daemon
- **`earlyoom`** — Out-of-memory prevention daemon
- **KDE Connect** — Secured with persistent `firewalld` rules (no open ports by default)
- **BlackArch integration** via `zarch-hacking` — tools available on-demand, not running as services

---

## Package Security

Custom ZarchBlack packages in the `[zarchblack-repo]` repository are:
- Built from source PKGBUILDs stored in this repository (fully auditable)
- Signed with the ZarchBlack GPG key

---

*This security policy follows responsible disclosure best practices.*
