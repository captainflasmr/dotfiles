#!/bin/bash
# Auto-configure Sway output scaling based on display resolution.
# Runs on startup and can be re-run when outputs change.

swaymsg -t get_outputs | jq -r '
    .[] | select(.active == true) |
    (if .current_mode.width >= 1920 then "1.0"
     else "1.0" end) as $scale |
    "swaymsg output \(.name) scale \($scale)"
' | while read -r cmd; do
    eval "$cmd"
done
