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
  echo -e "${COLOR_RED}[Error] This script must be run as root (using sudo)${COLOR_RESET}"
  echo "Usage: sudo $0"
  exit 1
fi

if [[ ! -f "$KEY_PATH" ]]; then
  echo -e "${COLOR_RED}[Error] GPG public key not found at: $KEY_PATH${COLOR_RESET}"
  exit 1
fi

echo "Adding ZarchBlack key to pacman keyring..."
pacman-key --add "$KEY_PATH"

echo "Locally signing and trusting the key..."
pacman-key --lsign-key "$KEY_EMAIL"

echo -e "${COLOR_CYAN}[Success] GPG key added and trusted successfully! Pacman can now verify ZarchBlack packages.${COLOR_RESET}"
