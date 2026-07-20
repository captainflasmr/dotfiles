#!/bin/sh
# Toggle swayidle on/off

if pgrep -x swayidle > /dev/null 2>&1; then
    pkill -x swayidle
else
    swayidle -w \
        timeout 240 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"' \
        before-sleep 'swaymsg "output * dpms off"' \
        after-resume 'swaymsg "output * dpms on"' &
fi

pkill -RTMIN+1 waybar
