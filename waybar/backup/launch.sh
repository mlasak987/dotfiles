#!/bin/dash
CONFIG_FILES="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/style.css"

trap "killall waybar" EXIT

while true; do
    killall waybar
    waybar &
    inotifywait -e create,modify $CONFIG_FILES
done
