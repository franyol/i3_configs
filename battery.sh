#!/bin/bash

# Get battery status and percentage using `acpi`
STATUS=$(acpi -b | awk -F', ' '{print $1}' | awk '{print $3}' | tr -d ',')
PERCENT=$(acpi -b | awk -F', ' '{print $2}' | tr -d '%')

# Display battery percentage
echo "🔋 $PERCENT% - $STATUS"

# Send alert only if discharging and below 15%
THRESHOLD=99
FLAG_FILE="/tmp/.battery_warned"

touch "$FLAG_FILE"

if [[ "$STATUS" == "Discharging" && "$PERCENT" -le "$THRESHOLD" ]]; then
  if [[ ! -f "$FLAG_FILE" ]]; then
    notify-send -u critical "⚠️ LOW BATTERY" "Battery is at $PERCENT%"
    touch "$FLAG_FILE"
  fi
else
  # Remove flag if battery is charging or above threshold
  [[ -f "$FLAG_FILE" ]] && rm "$FLAG_FILE"
fi
