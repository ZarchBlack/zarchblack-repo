#!/bin/bash
# ===================================================================
# ZarchBlack ISO Upload Helper Script
# Uploads the built ISO file to Hugging Face
# ===================================================================

COLOR_CYAN="\033[0;36m"
COLOR_PURPLE="\033[0;35m"
COLOR_RED="\033[0;31m"
COLOR_RESET="\033[0m"

echo -e "${COLOR_PURPLE}==================================================${COLOR_RESET}"
echo -e "${COLOR_CYAN}         ZarchBlack ISO Upload Helper            ${COLOR_RESET}"
echo -e "${COLOR_PURPLE}==================================================${COLOR_RESET}"

# 1. Search for ISO file in output directories
SEARCH_DIRS=("./out" "/home/zarch/zarchblack_iso/out" "/home/zarch/out")
ISO_PATH=""

for dir in "${SEARCH_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        ISO_PATH=$(find "$dir" -name "*.iso" -type f 2>/dev/null | head -n 1)
        if [ -n "$ISO_PATH" ]; then
            break
        fi
    fi
done

if [ -z "$ISO_PATH" ]; then
    echo -e "${COLOR_RED}[Error] No .iso file found in search paths.${COLOR_RESET}"
    echo "Please ensure the ISO build completed successfully."
    exit 1
fi

ISO_NAME=$(basename "$ISO_PATH")
echo -e "Found ISO: ${COLOR_CYAN}$ISO_NAME${COLOR_RESET}"

# 2. Check Hugging Face CLI login status
echo "Checking Hugging Face login status..."
hf auth whoami >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${COLOR_RED}[Warning] You are not currently logged in to Hugging Face CLI.${COLOR_RESET}"
    echo "Please enter your access token from: https://huggingface.co/settings/tokens"
    echo "Running login command now..."
    hf auth login
    if [ $? -ne 0 ]; then
        echo -e "${COLOR_RED}[Error] Login failed. Please try again.${COLOR_RESET}"
        exit 1
    fi
fi

# 3. Confirm upload
echo -e "Target Hugging Face repository: ${COLOR_CYAN}zarchblack/zarchblack-releases${COLOR_RESET}"
read -p "Start uploading now? (y/N): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Uploading ISO file... This may take a while depending on your network connection."
    hf upload zarchblack/zarchblack-releases "$ISO_PATH" "$ISO_NAME" --repo-type dataset
    if [ $? -eq 0 ]; then
        echo -e "${COLOR_CYAN}[Success] ISO uploaded successfully to Hugging Face!${COLOR_RESET}"
        echo "URL: https://huggingface.co/datasets/zarchblack/zarchblack-releases/tree/main"
    else
        echo -e "${COLOR_RED}[Error] Upload failed. Check your connection and try again.${COLOR_RESET}"
    fi
else
    echo "Upload cancelled."
fi
