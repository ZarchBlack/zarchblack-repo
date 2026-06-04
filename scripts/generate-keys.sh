#!/usr/bin/env bash
# ===================================================================
# ZarchBlack GPG Key Generator Script
# Generates a secure GPG key pair for signing repository packages
# ===================================================================
set -euo pipefail

COLOR_CYAN="\033[0;36m"
COLOR_PURPLE="\033[0;35m"
COLOR_RED="\033[0;31m"
COLOR_RESET="\033[0m"

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
KEYS_DIR="${PROJECT_DIR}/keys"
KEY_EMAIL="security@zarchblack.org"
KEY_NAME="ZarchBlack Distribution Security"

echo -e "${COLOR_PURPLE}==================================================${COLOR_RESET}"
echo -e "${COLOR_CYAN}         ZarchBlack GPG Key Generator            ${COLOR_RESET}"
echo -e "${COLOR_PURPLE}==================================================${COLOR_RESET}"

# 1. إنشاء ملف الإعداد المؤقت لتوليد المفاتيح بدون تدخل تفاعلي
TMP_BATCH=$(mktemp)
cat <<EOF > "$TMP_BATCH"
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: ${KEY_NAME}
Name-Email: ${KEY_EMAIL}
Expire-Date: 0
%no-ask-passphrase
%no-protection
%commit
EOF

echo "جاري توليد زوج مفاتيح GPG (4096-bit)... قد يستغرق هذا بضع ثوانٍ..."
gpg --batch --generate-key "$TMP_BATCH"
rm -f "$TMP_BATCH"

# 2. البحث عن معرّف المفتاح المتولد
echo "البحث عن المفتاح المنشأ حديثاً..."
KEY_ID=$(gpg --list-keys --with-colons "${KEY_EMAIL}" 2>/dev/null | grep "^pub" | cut -d: -f5)

if [ -z "$KEY_ID" ]; then
    echo -e "${COLOR_RED}[خطأ] فشل في العثور على المفتاح بعد التوليد.${COLOR_RESET}"
    exit 1
fi

echo -e "تم العثور على المفتاح بمعرّف: ${COLOR_CYAN}${KEY_ID}${COLOR_RESET}"

# 3. تصدير المفتاح العام إلى مجلد keys/
echo "تصدير المفتاح العام إلى keys/zarchblack.gpg..."
mkdir -p "$KEYS_DIR"
gpg --export --armor "${KEY_EMAIL}" > "${KEYS_DIR}/zarchblack.gpg"
echo -e "${COLOR_CYAN}[نجاح] تم تصدير المفتاح العام إلى: ${KEYS_DIR}/zarchblack.gpg${COLOR_RESET}"

# 4. توجيه المستخدم لكيفية تصدير المفتاح الخاص للـ CI/CD
echo -e "\n${COLOR_PURPLE}--------------------------------------------------${COLOR_RESET}"
echo -e "${COLOR_CYAN}   خطوات تفعيل الأتمتة على GitHub Actions:${COLOR_RESET}"
echo -e "${COLOR_PURPLE}--------------------------------------------------${COLOR_RESET}"
echo "لتمكين البناء التلقائي من توقيع الحزم، يرجى تشغيل الأمر التالي لتصدير المفتاح الخاص:"
echo -e "${COLOR_CYAN}gpg --export-secret-keys --armor \"${KEY_EMAIL}\" | base64 -w 0${COLOR_RESET}"
echo -e "\nثم قم بنسخ النص الناتج وإضافته في إعدادات مستودعك على GitHub كسرّ بالاسم التالي:"
echo -e "الاسم: ${COLOR_CYAN}GPG_PRIVATE_KEY${COLOR_RESET}"
echo -e "${COLOR_PURPLE}--------------------------------------------------${COLOR_RESET}"
