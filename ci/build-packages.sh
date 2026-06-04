#!/usr/bin/env bash
# ===================================================================
# ZarchBlack CI/CD Package Builder Script
# Designed to run inside archlinux:latest container in GitHub Actions
# ===================================================================
set -euo pipefail

COLOR_CYAN="\033[0;36m"
COLOR_RESET="\033[0m"

echo -e "${COLOR_CYAN}=== ZarchBlack Package Builder Start ===${COLOR_RESET}"

# 1. تهيئة مدير الحزم ومفاتيح النظام
echo "Initializing pacman keyring..."
pacman-key --init
pacman-key --populate archlinux

# إضافة مستودع ZarchBlack الحالي لحل التبعيات المتبادلة
echo "Adding current zarchblack-repo to pacman.conf..."
cat <<EOF >> /etc/pacman.conf

[zarchblack-repo]
SigLevel = Required DatabaseOptional
Server = https://github.com/ZarchBlack/zarchblack-repo/releases/download/repo
EOF

# استيراد مفتاح التوزيعة العام لتثبيت التبعيات الموقعة
if [ -f "/workspace/keys/zarchblack.gpg" ]; then
    echo "Importing ZarchBlack public key to keyring..."
    pacman-key --add /workspace/keys/zarchblack.gpg
    pacman-key --lsign-key security@zarchblack.org
fi

# تحديث النظام الأساسي وتثبيت أدوات التطوير الأساسية وفحص الجودة
echo "Updating package databases and installing devtools/namcap..."
pacman -Sy --noconfirm --needed base-devel git namcap

# 2. استيراد مفتاح GPG الخاص للتوقيع الرقمي
if [ -n "${GPG_PRIVATE_KEY:-}" ]; then
    echo "Importing GPG Private Key for package signing..."
    echo "$GPG_PRIVATE_KEY" | base64 -d | gpg --batch --import
else
    echo "WARNING: GPG_PRIVATE_KEY is not set. Packages will not be signed."
fi

# 3. إعداد مستخدم البناء (makepkg لا يعمل بصلاحيات root)
echo "Setting up non-root builder user..."
useradd -m builder
echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder
chmod 440 /etc/sudoers.d/builder

# تهيئة مجلد المخرجات المؤقت
REPOS_DIR="/workspace/repo-output"
mkdir -p "$REPOS_DIR"
chown -R builder:builder /workspace "$REPOS_DIR"

# 4. تحديد الحزم المطلوب بناؤها
# نقرأ الحزم الممررة كوسيط أو نبني الحزم المعدلة فقط
CHANGED_PACKAGES=()
if [ $# -gt 0 ]; then
    CHANGED_PACKAGES=("$@")
else
    echo "No packages specified. Scanning packages/ directory..."
    cd /workspace/packages
    for pkg in *; do
        if [ -d "$pkg" ] && [ -f "$pkg/PKGBUILD" ]; then
            CHANGED_PACKAGES+=("$pkg")
        fi
    done
fi

echo "Packages to build: ${CHANGED_PACKAGES[*]}"

# 5. حلقة بناء الحزم
for pkg in "${CHANGED_PACKAGES[@]}"; do
    echo -e "${COLOR_CYAN}--- Building package: $pkg ---${COLOR_RESET}"
    PKG_SRC_DIR="/workspace/packages/$pkg"
    
    if [ ! -d "$PKG_SRC_DIR" ]; then
        echo "Error: Directory $PKG_SRC_DIR does not exist."
        exit 1
    fi
    
    # فحص ملف PKGBUILD بـ Namcap أولاً قبل البناء
    echo "Linting PKGBUILD with namcap..."
    namcap -i "$PKG_SRC_DIR/PKGBUILD" || true
    
    # بناء الحزمة كمستخدم builder
    echo "Running makepkg..."
    cd "$PKG_SRC_DIR"
    # مسح أي ملفات بناء سابقة
    rm -rf src/ pkg/ *.pkg.tar.zst *.sig 2>/dev/null || true
    
    su builder -c "makepkg --syncdeps --noconfirm --clean"
    
    # التحقق من نجاح البناء
    BUILT_FILE=$(find . -name "*.pkg.tar.zst" -type f | head -n 1)
    if [ -z "$BUILT_FILE" ]; then
        echo "Error: Build failed for package $pkg (no .pkg.tar.zst generated)."
        exit 1
    fi
    
    echo "Successfully built: $BUILT_FILE"
    
    # فحص جودة الحزمة الثنائية بـ Namcap
    echo "Linting built package with namcap..."
    namcap -i "$BUILT_FILE" || true
    
    # توقيع الحزمة رقمياً بمفتاح GPG
    if [ -n "${GPG_PRIVATE_KEY:-}" ]; then
        echo "Signing package with GPG..."
        # makepkg يقوم بالتوقيع تلقائياً إذا تم إعداده، ولكننا نوقع يدوياً هنا لضمان التطبيق الفوري
        su builder -c "gpg --detach-sign --no-armor --local-user security@zarchblack.org $BUILT_FILE"
        if [ ! -f "${BUILT_FILE}.sig" ]; then
            echo "Error: Failed to sign package $pkg."
            exit 1
        fi
        echo "Signature created: ${BUILT_FILE}.sig"
        cp "${BUILT_FILE}.sig" "$REPOS_DIR/"
    fi
    
    # نقل الملفات إلى المجلد المشترك للمخرجات
    cp "$BUILT_FILE" "$REPOS_DIR/"
done

echo -e "${COLOR_CYAN}=== ZarchBlack Package Builder Complete ===${COLOR_RESET}"
