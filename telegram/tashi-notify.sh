#!/bin/bash
# Send a Telegram notification + log locally
# Usage: tashi-notify "Your message here"
#
# This is installed globally at /usr/local/bin/tashi-notify
# Bot: @tashisleepy_ai_bot

MSG="$1"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
LOG_FILE="$HOME/.omc/notification-log.md"

# Load config
BOT_TOKEN=$(python3 -c "import json; print(json.load(open('$HOME/.omc/notifications.json'))['telegram']['bot_token'])" 2>/dev/null)
CHAT_ID=$(python3 -c "import json; print(json.load(open('$HOME/.omc/notifications.json'))['telegram']['chat_id'])" 2>/dev/null)

if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
  echo "Error: Telegram not configured. Run scripts/setup-telegram.sh first."
  exit 1
fi

# Send to Telegram
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -H "Content-Type: application/json" \
  -d "{\"chat_id\": ${CHAT_ID}, \"text\": \"$MSG\", \"parse_mode\": \"Markdown\"}" > /dev/null 2>&1

# Log locally
echo "- [$TIMESTAMP] $MSG" >> "$LOG_FILE"
