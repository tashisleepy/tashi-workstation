#!/bin/bash
# Telegram Bot Notification Setup
# Creates the notify command and config.
#
# Prerequisites: You need a Telegram bot token from @BotFather
# and your chat ID (send /start to your bot, then check getUpdates)
#
# Usage: ./scripts/setup-telegram.sh <BOT_TOKEN> <CHAT_ID>

set -e

BOT_TOKEN="${1:?Usage: ./scripts/setup-telegram.sh <BOT_TOKEN> <CHAT_ID>}"
CHAT_ID="${2:?Usage: ./scripts/setup-telegram.sh <BOT_TOKEN> <CHAT_ID>}"

echo "Setting up Telegram notifications..."

# ── Config file ──
mkdir -p ~/.omc
cat > ~/.omc/notifications.json << EOF
{
  "telegram": {
    "enabled": true,
    "bot_token": "$BOT_TOKEN",
    "chat_id": "$CHAT_ID"
  }
}
EOF
echo "Config saved: ~/.omc/notifications.json"

# ── Notification log ──
if [ ! -f ~/.omc/notification-log.md ]; then
  echo "# Tashi AI — Notification Log" > ~/.omc/notification-log.md
  echo "" >> ~/.omc/notification-log.md
fi

# ── Notify command ──
cat > /usr/local/bin/tashi-notify << SCRIPT
#!/bin/bash
MSG="\$1"
TIMESTAMP=\$(date "+%Y-%m-%d %H:%M:%S")
LOG_FILE="\$HOME/.omc/notification-log.md"

curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \\
  -H "Content-Type: application/json" \\
  -d "{\"chat_id\": $CHAT_ID, \"text\": \"\$MSG\", \"parse_mode\": \"Markdown\"}" > /dev/null 2>&1

echo "- [\$TIMESTAMP] \$MSG" >> "\$LOG_FILE"
SCRIPT
chmod +x /usr/local/bin/tashi-notify
echo "Command installed: tashi-notify"

# ── Test ──
tashi-notify "Telegram notifications configured and working."
echo ""
echo "Done! Test with: tashi-notify \"Hello from Terminal\""
echo "View log with: cat ~/.omc/notification-log.md"
