#!/usr/bin/bash
if cat /proc/acpi/button/lid/LID0/state | grep -q open; then
    swaymsg output <eDP-1> enable
else
    swaymsg output <eDP-1> disable
fi
