#!/bin/bash

# ===== CONFIG =====
BOT_TOKEN="7260570513:AAFtQtFWN-TuPSQLY70UMEN-sR28en8dcpQ"
CHAT_ID="6767911255"

BASE_DIR="/root/push-ip-public"
IP_FILE="$BASE_DIR/ip.txt"
LOG_FILE="$BASE_DIR/ip.log"

# ===== GET PUBLIC IP =====
NEW_IP=$(curl -s https://api.ipify.org || curl -s https://ifconfig.me)

# ===== Write log eror =====
if [ -z "$NEW_IP" ]; then
    echo "$(date) - ERROR: Không lấy được IP" >> "$LOG_FILE"
    exit 1
fi

# ===== GET OLD IP =====
if [ -f "$IP_FILE" ]; then
    OLD_IP=$(cat "$IP_FILE")
else
    OLD_IP=""
fi

# ===== COMPARE =====
if [ "$NEW_IP" != "$OLD_IP" ]; then
    echo "$NEW_IP" > "$IP_FILE"

    MESSAGE="🔄 The new IP Public's DNG: $NEW_IP
🖥 Server: $(hostname)
⏰ Time: $(date "+%Y%m%d_%H:%M:%S")"

    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$MESSAGE"

    echo "$(date) - IP changed: $NEW_IP" >> "$LOG_FILE"
else
    echo "$(date) - No change ($NEW_IP)" >> "$LOG_FILE"
fi