#!/bin/bash

# Get battery status and percentage using `acpi`
STATUS=$(acpi -b | awk -F', ' '{print $1}' | awk '{print $3}' | tr -d ',')
PERCENT=$(acpi -b | awk -F', ' '{print $2}' | tr -d '%')

# Display battery percentage
echo "🔋 $PERCENT% - $STATUS"

# Send alert only if discharging and below 15%
THRESHOLD=25
FLAG_FILE="/tmp/.battery_warned"

# Ensure file exists only when needed (do NOT pre-touch it)

if [[ "$STATUS" == "Discharging" && "$PERCENT" -le "$THRESHOLD" ]]; then

  # Create flag only after first warning
  if [[ ! -f "$FLAG_FILE" ]]; then
    notify-send -u critical "⚠️ LOW BATTERY" "Battery is at ${PERCENT}%"
    echo "$(date +%s)" >"$FLAG_FILE"
  fi

else
  # Reset flag when condition is no longer true
  rm -f "$FLAG_FILE"
fi
