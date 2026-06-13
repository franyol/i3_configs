#!/bin/bash

case "$BLOCK_BUTTON" in
1) pavucontrol & ;;
4) pactl set-sink-volume @DEFAULT_SINK@ +5% ;;
5) pactl set-sink-volume @DEFAULT_SINK@ -5% ;;
esac

amixer get Master | awk -F'[][]' '/%/ {print "🔊 " $2; exit}'
