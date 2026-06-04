#!/usr/bin/env bash
# ===================================================================
# ZarchBlack Host Pacman Keyring Setup Script
# Imports the distribution's GPG public key and trusts it on the host
# ===================================================================
set -euo pipefail

COLOR_CYAN="\033[0;36m"
COLOR_PURPLE="\033[0;35m"
COLOR_RED="\033[0;31m"
COLOR_RESET="\033[0m"

KEY_EMAIL="security@zarchblack.org"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
KEY_PATH="${PROJECT_DIR}/keys/zarchblack.gpg"

echo -e "${COLOR_PURPLE}==================================================${COLOR_RESET}"
echo -e "${COLOR_CYAN}    ZarchBlack Host Pacman Keyring Setup         ${COLOR_RESET}"
echo -e "${COLOR_PURPLE}==================================================${COLOR_RESET}"

if [[ $EUID -ne 0 ]]; then
  echo -e "${COLOR_RED}[خطأ] يجب تشغيل هذا السكربت بصلاحيات root (باستخدام sudo)${COLOR_RESET}"
  echo "الاستخدام: sudo $0"
  exit 1
fi

if [[ ! -f "$KEY_PATH" ]]; then
  echo -e "${COLOR_RED}[خطأ] لم يتم العثور على المفتاح العام في: $KEY_PATH${COLOR_RESET}"
  exit 1
fi

echo "جاري إضافة مفتاح ZarchBlack إلى حلقة مفاتيح pacman..."
pacman-key --add "$KEY_PATH"

echo "جاري التوقيع والتفويض للمفتاح..."
pacman-key --lsign-key "$KEY_EMAIL"

echo -e "${COLOR_CYAN}[نجاح] تم إضافة وتفويض المفتاح بنجاح! يمكن لـ pacman الآن التحقق من تواقيع حزم ZarchBlack.${COLOR_RESET}"
