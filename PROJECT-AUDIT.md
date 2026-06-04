# ZarchBlack Project Audit Report (PROJECT-AUDIT.md)

This document presents a comprehensive diagnostic audit of the current **ZarchBlack** project architecture, covering the ISO build configuration, local repository scripts, packages directory, and infrastructure risks.

---

## 1. Current Directory Structure
The repository `/home/zarch/zarchblack_iso` currently contains the following structure:
* `packages/`: Contains 14 custom packages (PKGBUILDs).
* `local-repo/`: An ad-hoc directory for local repository creation and testing.
* `kde-releng/`: The main `archiso` profile directory containing `profiledef.sh`, package lists, and the custom `airootfs` system.
* `scripts/`: Local scripts for building the ISO (`build-iso.sh`) and updating the database (`update-repo.sh`).
* `configs/`, `plasma/`, `themes/`, `wayland/`, `wallpapers/`: Resource directories containing theme files and UI customizations.
* `.github/`: Contains basic templates but **no CI/CD workflows**.

---

## 2. Existing Systems (What works?)
* **Local ISO Build System:** The `mkarchiso` configuration is fully functional. Network manager conflicts have been resolved, Wayland icon mapping works, and SquashFS OOM errors have been mitigated.
* **PKGBUILD Specifications:** The 14 directories in `packages/` contain correct PKGBUILD layouts that allow building packages locally.
* **Hosting Model:** The external repository `zarchblack-repo` is hosted on GitHub Pages and serves package binaries successfully.

---

## 3. Broken and Inefficient Parts (What doesn't work well?)
* **Host-dependent Builds:** Packages are built directly on the host system. This results in dependency contamination, where a package compiles successfully because of packages installed on the host developer's machine but fails when installed on a clean target system.
* **No Database Automation:** The database database file (`zarchblack-repo.db`) and packages must be manually committed and pushed.
* **Unsigned Packages:** The repository does not utilize GPG signatures. The client's `pacman.conf` has to use `SigLevel = Optional TrustAll` (or database-optional without verification), which is insecure.

---

## 4. Missing Components
* **CI/CD System:** No `.github/workflows/` files exist to automate build tasks on code push.
* **Clean Chroot Infrastructure:** No automated tooling (`devtools`/`extra-x86_64-build`) is configured to ensure builds are compiled in isolated roots.
* **Package Linting:** No `namcap` checks are run to verify package quality before release.
* **GPG Keys Directory & Automation:** No automated script/configuration for signing built packages or the package database.

---

## 5. Security & Technical Risks

> [!WARNING]
> **1. Absence of GPG Verification (High Risk)**
> Serving unsigned packages over GitHub Pages means that if a developer account is compromised or a man-in-the-middle attack occurs, malicious packages can be pushed to users without `pacman` generating any security warnings.

> [!CAUTION]
> **2. Environment Contamination (Medium Risk)**
> Building packages outside of a clean chroot can lead to "ghost dependencies." A package might link against a library present on the host system that is not defined in the `depends` array of the PKGBUILD. When installed on the ISO, the application will crash with library load errors.

> [!NOTE]
> **3. Large Binary Commit Limits (Low-Medium Risk)**
> Pushing packages directly to GitHub repository limits can violate GitHub's file size guidelines (100MB limit per file). Large packages must be offloaded to GitHub Releases while metadata remains on GitHub Pages.

---

## 6. Project Conflicts
* **Script Redundancy:** There are two separate `update-repo.sh` scripts: one in `/home/zarch/zarchblack_iso/scripts/update-repo.sh` and one in `/home/zarch/zarchblack_iso/local-repo/update-repo.sh`. These have slightly different configurations and cause confusion.
* **Repository Separation:** The build repository `zarchblack-iso` and the release repository `zarchblack-repo` are split, requiring manual synchronization.
