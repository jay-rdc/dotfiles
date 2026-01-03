#!/bin/bash

option1="󰌾 Lock"
option2="󰍃 Logout"
option3="󰜉 Reboot"
option4="󰐥 Shutdown"

options="$option1\n$option2\n$option3\n$option4"

selected=$(echo -e "$options" | fuzzel -d --width 20 --lines 4)

case $selected in
  "$option1")
    qs ipc call lockscreen setLocked true
    ;;
  "$option2")
    niri msg action quit --skip-confirmation
    ;;
  "$option3")
    systemctl reboot
    ;;
  "$option4")
    systemctl poweroff
    ;;
esac
