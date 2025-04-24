#!/bin/bash

TARGET_DIR="/home/"

LOG_FILE="/home/scanner/malware_scan_$(date +%F).log"

KEYWORDS="eval|base64_decode|gzinflate|shell_exec|passthru|system|exec|popen|proc_open"

echo "[*] Memulai scanning di $TARGET_DIR" | tee $LOG_FILE
echo "[*] Mencari file mencurigakan..." | tee -a $LOG_FILE

find "$TARGET_DIR" -type f \( -iname "*.php" -o -iname "*.pl" -o -iname "*.phtml" -o -iname "*.shtml" -o -iname "*.alfa" -o -iname "*.py" \) -exec grep -Ei "$KEYWORDS" {} \; -print >> $LOG_FILE

echo -e "\n[*] Mencari file dengan permission 777..." | tee -a $LOG_FILE
find "$TARGET_DIR" -type f -perm 0777 >> $LOG_FILE

echo -e "\n[*] File yang dimodifikasi dalam 1 hari terakhir..." | tee -a $LOG_FILE
find "$TARGET_DIR" -type f -mtime -1 >> $LOG_FILE

echo -e "\n[*] File tersembunyi..." | tee -a $LOG_FILE
find "$TARGET_DIR" -type f -name ".*" >> $LOG_FILE

echo -e "\n[*] Cronjob user..." | tee -a $LOG_FILE
crontab -l >> $LOG_FILE 2>/dev/null

echo -e "\n[✓] Selesai scan. Cek hasil di $LOG_FILE"
