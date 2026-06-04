#!/bin/bash

# ZarchBlack ISO Upload Helper Script
# هذا السكربت يساعدك على رفع نسخة الأيزو النهائية إلى Hugging Face بسهولة.

COLOR_CYAN="\033[0;36m"
COLOR_PURPLE="\033[0;35m"
COLOR_RED="\033[0;31m"
COLOR_RESET="\033[0m"

echo -e "${COLOR_PURPLE}==================================================${COLOR_RESET}"
echo -e "${COLOR_CYAN}         ZarchBlack ISO Upload Helper            ${COLOR_RESET}"
echo -e "${COLOR_PURPLE}==================================================${COLOR_RESET}"

# 1. البحث عن ملف الأيزو في مجلد المخرجات
OUT_DIR="/home/zarch/out"
ISO_PATH=$(find "$OUT_DIR" -name "*.iso" -type f 2>/dev/null | head -n 1)

if [ -z "$ISO_PATH" ]; then
    echo -e "${COLOR_RED}[خطأ] لم يتم العثور على أي ملف .iso في المجلد $OUT_DIR${COLOR_RESET}"
    echo "يرجى التأكد من إتمام عملية بناء الأيزو بنجاح أولاً."
    exit 1
fi

ISO_NAME=$(basename "$ISO_PATH")
echo -e "تم العثور على نسخة الأيزو: ${COLOR_CYAN}$ISO_NAME${COLOR_RESET}"

# 2. التحقق من حالة تسجيل الدخول في Hugging Face
echo "التحقق من تسجيل الدخول في Hugging Face..."
hf auth whoami >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${COLOR_RED}[تنبيه] أنت غير مسجل الدخول حالياً في Hugging Face CLI.${COLOR_RESET}"
    echo "يرجى إدخال رمز الدخول الخاص بك (Token) من الرابط التالي: https://huggingface.co/settings/tokens"
    echo "سيتم تشغيل أمر تسجيل الدخول الآن..."
    hf auth login
    if [ $? -ne 0 ]; then
        echo -e "${COLOR_RED}[خطأ] فشل تسجيل الدخول. يرجى إعادة المحاولة.${COLOR_RESET}"
        exit 1
    fi
fi

# 3. تأكيد الرفع
echo -e "سيتم رفع الملف إلى المستودع: ${COLOR_CYAN}zarchblack/zarchblack-releases${COLOR_RESET}"
read -p "هل تريد البدء في عملية الرفع الآن؟ (y/N): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "جاري رفع ملف الأيزو... قد يستغرق هذا بعض الوقت اعتماداً على سرعة الإنترنت."
    hf upload zarchblack/zarchblack-releases "$ISO_PATH" "$ISO_NAME" --repo-type dataset
    if [ $? -eq 0 ]; then
        echo -e "${COLOR_CYAN}[نجاح] تم رفع نسخة الأيزو بنجاح إلى Hugging Face!${COLOR_RESET}"
        echo "الرابط: https://huggingface.co/datasets/zarchblack/zarchblack-releases/tree/main"
    else
        echo -e "${COLOR_RED}[خطأ] حدثت مشكلة أثناء الرفع. يرجى التحقق من الاتصال والمحاولة مرة أخرى.${COLOR_RESET}"
    fi
else
    echo "تم إلغاء عملية الرفع."
fi
