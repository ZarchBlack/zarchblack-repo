# Package Lists

This directory contains the modular package lists for ZarchBlack.

## Structure

Each `.txt` file represents a logical category of packages:

| File | Content |
|---|---|
| `01-base.txt` | Core system, kernel, initramfs |
| `02-hardware.txt` | Drivers, CPU, storage, GPU, bluetooth |
| `03-networking.txt` | NetworkManager, firewall, VPN, tools |
| `04-audio.txt` | PipeWire, ALSA, GStreamer, codecs |
| `05-kde-plasma.txt` | KDE Plasma 6, SDDM, frameworks |
| `06-applications.txt` | Browsers, office, multimedia, productivity |
| `07-development.txt` | Development tools, compilers, git |
| `08-security.txt` | Security tools, firejail, apparmor |
| `09-theming.txt` | Themes, icons, fonts, cursors |
| `10-chaotic-aur.txt` | Packages from Chaotic-AUR |
| `11-zarchblack-local.txt` | Custom ZarchBlack packages |

## Usage

To regenerate `iso/packages.x86_64` from these files:
```bash
./scripts/generate-packages.sh
```

> **Note:** The main `iso/packages.x86_64` file is what archiso actually reads.
> Always run `generate-packages.sh` after editing files here.
