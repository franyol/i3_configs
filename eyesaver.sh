#!/bin/bash

TEMP=4700
STATE_FILE="/tmp/eyesaver"

if [ "$BLOCK_BUTTON" = "1" ]; then
  if [ -f "$STATE_FILE" ]; then
    redshift -x >/dev/null 2>&1
    pkill -x redshift >/dev/null 2>&1
    rm -f "$STATE_FILE"
  else
    redshift -O "$TEMP" >/dev/null 2>&1
    touch "$STATE_FILE"
  fi
fi

if [ -f "$STATE_FILE" ]; then
  echo "👁️ ON"
else
  echo "👁️ OFF"
fi
