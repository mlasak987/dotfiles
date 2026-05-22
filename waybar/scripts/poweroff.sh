#!/bin/bash

OPTIONS="Shutdown\nReboot\nLog off\nSleep\nLock\nCancel"

case $(echo -e "$OPTIONS" | rofi -dmenu -i -p "Power:") in
    "Shutdown")
        systemctl poweroff
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Sleep")
        systemctl suspend
        ;;
    "Lock")
        loginctl lock-session
        ;;
    "Log off")
        hyprctl dispatch exit
        ;;
    "Cancel"|*)
        exit
        ;;
esac
