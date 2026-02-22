#!/bin/bash

WALL1="$HOME/Pictures/Wallpapers/1.jpg"
WALL2="$HOME/Pictures/Wallpapers/2.jpg"
STATE_FILE="$HOME/Pictures/Wallpapers/WALL"

CURRENT_STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "1")

if [ "$CURRENT_STATE" == "1" ]; then
    hyprctl hyprpaper wallpaper "eDP-1,$WALL2"
    echo "2" > "$STATE_FILE"
else
    hyprctl hyprpaper wallpaper "eDP-1,$WALL1"
    echo "1" > "$STATE_FILE"
fi
