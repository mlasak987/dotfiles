#!/bin/bash

WALL1="$HOME/Pictures/Wallpapers/1.jpg"
WALL2="$HOME/Pictures/Wallpapers/2.jpg"
STATE_FILE="$HOME/Pictures/Wallpapers/WALL"

TRANSITION="--transition-type wipe --transition-angle 30 --transition-step 90"

CURRENT_STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "1")

if [ "$CURRENT_STATE" == "1" ]; then
    awww img -o eDP-1 "$WALL2" $TRANSITION
    echo "2" > "$STATE_FILE"
else
    awww img -o eDP-1 "$WALL1" $TRANSITION
    echo "1" > "$STATE_FILE"
fi
