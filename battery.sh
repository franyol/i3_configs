#!/bin/bash

THRESHOLD=20
CRITICAL=10
FLAG_FILE="/tmp/.battery_warned"

# Get battery info (single call, not repeated)
BATTERY=$(acpi -b | head -n1)

STATUS=$(echo "$BATTERY" | awk -F', ' '{print $1}' | awk '{print $3}')
PERCENT=$(echo "$BATTERY" | awk -F', ' '{print $2}' | tr -d '%')

# Fallback safety
PERCENT=${PERCENT:-0}

# Choose icon based on battery level
if ((PERCENT >= 90)); then
  ICON="󰁹"
elif ((PERCENT >= 70)); then
  ICON="󰂀"
elif ((PERCENT >= 50)); then
  ICON="󰁿"
elif ((PERCENT >= 30)); then
  ICON="󰁾"
elif ((PERCENT >= 15)); then
  ICON="󰁽"
else
  ICON="󰂃"
fi

# Status handling
COLOR="#ffffff"
STATE=""

case "$STATUS" in
Charging)
  STATE="⚡"
  COLOR="#00ff00"
  ;;
Full)
  STATE="✓"
  COLOR="#00ff00"
  ;;
Discharging)
  if ((PERCENT <= CRITICAL)); then
    COLOR="#ff0000"
  elif ((PERCENT <= THRESHOLD)); then
    COLOR="#ff5555"
  fi
  ;;
*)
  STATE="?"
  COLOR="#aaaaaa"
  ;;
esac

# Output for i3blocks:
# 1st line = display text
# 2nd line = tooltip (optional, same here)
# 3rd line = color
echo "$ICON $PERCENT% $STATE"
echo "Battery: $STATUS ($PERCENT%)"
echo "$COLOR"

# Notifications (only once per low-battery cycle)
if [[ "$STATUS" == "Discharging" && "$PERCENT" -le "$THRESHOLD" ]]; then
  if [[ ! -f "$FLAG_FILE" ]]; then
    notify-send -u critical "Low Battery" "Battery is at ${PERCENT}%"
    touch "$FLAG_FILE"
  fi

  if ((PERCENT <= CRITICAL)); then
    notify-send -u critical "CRITICAL BATTERY" "Plug in charger immediately!"
  fi
else
  rm -f "$FLAG_FILE"
fi
