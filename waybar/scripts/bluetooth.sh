#!/usr/bin/env bash

bluetoothctl power on > /dev/null
sleep 1

while true; do
    devices=$(bluetoothctl devices | sed 's/\x1b\[[0-9;]*m//g' | grep "Device " | sed 's/.*Device //')
    
    if [ -n "$devices" ]; then
        formatted_devices=$(echo "$devices" | awk 'NF>0 {mac=$1; $1=""; sub(/^[ \t]+/, ""); if ($0=="") $0="Unknown"; print $0 " (" mac ")"}')
    else
        formatted_devices=""
    fi

    menu_options="[ Scan for new devices ]\n$formatted_devices"

    chosen=$(echo -e "$menu_options" | wofi --dmenu -i --prompt "Bluetooth:")
    [ -z "$chosen" ] && exit

    if [ "$chosen" = "[ Scan for new devices ]" ]; then
        notify-send "Bluetooth" "Scanning for new devices... (5 seconds)"
        bluetoothctl --timeout 5 scan on > /dev/null
        continue
    else
        chosen_device="$chosen"
        break
    fi
done

mac=$(echo "$chosen_device" | grep -oE '([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}')
name=$(echo "$chosen_device" | sed "s/ ($mac)$//")

is_connected=$(bluetoothctl info "$mac" | grep -q "Connected: yes" && echo "yes" || echo "no")

if [ "$is_connected" == "yes" ]; then
    options="Disconnect\nForget"
else
    options="Connect\nForget"
fi

action=$(echo -e "$options" | wofi --dmenu -i --prompt "$name:" --width 250 --height 120)

case "$action" in
    "Connect")
        notify-send "Bluetooth" "Connecting to $name..."
        
        bluetoothctl trust "$mac" > /dev/null
        bluetoothctl pair "$mac" > /dev/null
        
        res=$(bluetoothctl connect "$mac" 2>&1)
        
        if echo "$res" | grep -qi "successful"; then
            notify-send "Bluetooth" "Connected with $name"
        else
            notify-send "Bluetooth" "Error connecting to $name"
        fi
        ;;
    "Disconnect")
        bluetoothctl disconnect "$mac" && notify-send "Bluetooth" "Disconnected from $name"
        ;;
    "Forget")
        bluetoothctl remove "$mac" && notify-send "Bluetooth" "$name has been forgotten"
        ;;
    *)
        exit
        ;;
esac
