#!/bin/bash

mapfile -t MONITORS < <(hyprctl monitors all | grep "^Monitor" | awk '{print $2}')

if [ ${#MONITORS[@]} -lt 2 ]; then
    notify-send "Monitors" "Only one monitor detected: ${MONITORS[0]}"
    exit 1
fi

MON_IN=""
MON_OUT=""

for m in "${MONITORS[@]}"; do
    if [[ "$m" == eDP* || "$m" == LVDS* ]]; then
        MON_IN="$m"
    elif [ -z "$MON_OUT" ]; then
        MON_OUT="$m"
    fi
done

if [ -z "$MON_IN" ]; then
    MON_IN="${MONITORS[0]}"
    MON_OUT="${MONITORS[1]}"
fi

OPTIONS="PC screen only ($MON_IN)\nExtend\nDuplicate\nSecond screen only ($MON_OUT)"

SELECTION=$(echo -e "$OPTIONS" | rofi -dmenu -p "Monitors:")

case "$SELECTION" in
    "PC screen only ($MON_IN)")
        hyprctl keyword monitor "$MON_IN, preferred, 0x0, 1"
        hyprctl keyword monitor "$MON_OUT, disable"
        ;;
    "Extend")
        hyprctl keyword monitor "$MON_IN, preferred, 0x0, 1"
        hyprctl keyword monitor "$MON_OUT, preferred, auto, 1"
        ;;
    "Duplicate")
        hyprctl keyword monitor "$MON_IN, preferred, 0x0, 1"
        hyprctl keyword monitor "$MON_OUT, preferred, auto, 1, mirror, $MON_IN"
        ;;
    "Second screen only ($MON_OUT)")
        hyprctl keyword monitor "$MON_IN, disable"
        hyprctl keyword monitor "$MON_OUT, preferred, 0x0, 1"
        ;;
esac
