#!/usr/bin/env bash

notify-send "Wi-Fi" "Scanning..."
wifi_list=$(nmcli -t -f SSID dev wifi list | grep -v '^--' | sort -u)

chosen_network=$(echo "$wifi_list" | rofi -dmenu -i -p "Select Wi-Fi:")
[ -z "$chosen_network" ] && exit

current_wifi=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)

if [ "$chosen_network" == "$current_wifi" ]; then
    options="Disconnect\nForget"
else
    options="Connect\nForget"
fi

action=$(echo -e "$options" | rofi -dmenu -i -p "$chosen_network:")

case "$action" in
    "Connect")
        saved_connections=$(nmcli -g NAME connection)
        if echo "$saved_connections" | grep -wqx "$chosen_network"; then
            nmcli connection up id "$chosen_network" && notify-send "Wi-Fi" "Connected with $chosen_network"
        else
            password=$(echo "" | rofi -dmenu -p "Password:" -password)
            [ -z "$password" ] && exit
            res=$(nmcli device wifi connect "$chosen_network" password "$password" 2>&1)
            if echo "$res" | grep -q "successfully"; then
                notify-send "Wi-Fi" "Connected with $chosen_network"
            else
                notify-send "Wi-Fi" "Error: $res"
            fi
        fi
        ;;
    "Disconnect")
        nmcli device disconnect wlan0 && notify-send "Wi-Fi" "Disconnected from $chosen_network"
        ;;
    "Forget")
        nmcli connection delete id "$chosen_network" && notify-send "Wi-Fi" "$chosen_network has been forgotten"
        ;;
    *)
        exit
        ;;
esac
