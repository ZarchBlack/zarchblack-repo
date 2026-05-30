# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| rolling | :white_check_mark: |

## Reporting a Vulnerability

This is a personal distribution project. Security issues should be reported via GitHub Issues.

## Security Features

- Firewalld with custom ZarchBlack zone
- UFW as alternative firewall
- Firejail for application sandboxing
- Polkit privilege management
- GPG signature verification for packages
- Encrypted filesystem support (LUKS, LVM)

## Build Security

- Local repository uses `Optional TrustAll` (development only)
- Production builds should enforce `Required` signature levels
- All custom packages are built in clean chroot environments
