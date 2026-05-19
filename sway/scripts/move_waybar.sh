#!/bin/bash

POSITION="${1:-top}"
CONFIG_FILE="$HOME/.config/waybar_active"

if [[ ! -f $CONFIG_FILE ]]; then
    echo "$HOME/.config/waybar" > "$CONFIG_FILE"
fi

CURRENT_CONFIG=$(cat "$CONFIG_FILE")

# Update position in the active config in-place
sed -i 's/"position": "[^"]*"/"position": "'"$POSITION"'"/' "$CURRENT_CONFIG/config"

# Adjust config for vertical vs horizontal
if [[ $POSITION == "left" || $POSITION == "right" ]]; then
    sed -i 's|.*"width":.*|    "width": 40,|' "$CURRENT_CONFIG/config"
    if ! grep -q '"width"' "$CURRENT_CONFIG/config"; then
        sed -i '/"position"/a\    "width": 40,' "$CURRENT_CONFIG/config"
    fi
    # Show short app_id instead of full title in narrow sidebar
    sed -i '/"sway\/window"/,/format/s/"format": "{}"/"format": "{app_id}"/' "$CURRENT_CONFIG/config"
    # Strip icons from module formats for narrow sidebar
    sed -i 's|"format": "󰋊 {percentage_used}%"|"format": "{percentage_used}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": " {usage}%"|"format": "{usage}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": " {temperatureC}°C"|"format": "{temperatureC}°C"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": " {}%"|"format": "{}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{icon} {volume}%"|"format": "{volume}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{icon} {capacity}%"|"format": "{capacity}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{icon} {percent}%"|"format": "{percent}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{icon} {temperatureC}"|"format": "{temperatureC}"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{icon} {volume}"|"format": "{volume}"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{icon} {capacity}"|"format": "{capacity}"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{icon} {percent}"|"format": "{percent}"|g' "$CURRENT_CONFIG/config"
    # Garuda-style formats (no space between icon and text)
    sed -i 's|"format": "   {used:0.1f}G"|"format": "{used:0.1f}G"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{icon}{percent: >3}%"|"format": "{percent: >3}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{icon}{volume: >3}%"|"format": "{volume: >3}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{icon}{capacity: >3}%"|"format": "{capacity: >3}%"|g' "$CURRENT_CONFIG/config"
else
    sed -i 's|.*"width":.*|    \/\/ "width": 40,|' "$CURRENT_CONFIG/config"
    sed -i '/"sway\/window"/,/format/s/"format": "{app_id}"/"format": "{}"/' "$CURRENT_CONFIG/config"
    # Restore icons in module formats for horizontal bar
    sed -i 's|"format": "{percentage_used}%"|"format": "󰋊 {percentage_used}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{usage}%"|"format": " {usage}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{temperatureC}°C"|"format": " {temperatureC}°C"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{}%"|"format": " {}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{volume}%"|"format": "{icon} {volume}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{capacity}%"|"format": "{icon} {capacity}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{percent}%"|"format": "{icon} {percent}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{temperatureC}"|"format": "{icon} {temperatureC}"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{volume}"|"format": "{icon} {volume}"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{capacity}"|"format": "{icon} {capacity}"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{percent}"|"format": "{icon} {percent}"|g' "$CURRENT_CONFIG/config"
    # Garuda-style formats (no space between icon and text)
    sed -i 's|"format": "{used:0.1f}G"|"format": "   {used:0.1f}G"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{percent: >3}%"|"format": "{icon}{percent: >3}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{volume: >3}%"|"format": "{icon}{volume: >3}%"|g' "$CURRENT_CONFIG/config"
    sed -i 's|"format": "{capacity: >3}%"|"format": "{icon}{capacity: >3}%"|g' "$CURRENT_CONFIG/config"
fi

# Adjust waybar margins based on position (gaps outer 0 in config keeps windows flush)
if [[ $POSITION == "bottom" ]]; then
    sed -i 's|"margin-bottom": [0-9-]*|"margin-bottom": 6|' "$CURRENT_CONFIG/config"
    sed -i 's|"margin-top": [0-9-]*|"margin-top": 0|' "$CURRENT_CONFIG/config"
    grep -q 'margin-bottom' "$CURRENT_CONFIG/config" || \
        sed -i '/"position"/a\    "margin-bottom": 6,' "$CURRENT_CONFIG/config"
elif [[ $POSITION == "left" || $POSITION == "right" ]]; then
    sed -i 's|"margin-bottom": [0-9-]*|"margin-bottom": 8|' "$CURRENT_CONFIG/config"
    sed -i 's|"margin-top": [0-9-]*|"margin-top": 8|' "$CURRENT_CONFIG/config"
else
    sed -i 's|"margin-bottom": [0-9-]*|"margin-bottom": -4|' "$CURRENT_CONFIG/config"
    sed -i 's|"margin-top": [0-9-]*|"margin-top": 3|' "$CURRENT_CONFIG/config"
fi

# Restart waybar
killall waybar 2>/dev/null
waybar -c "$CURRENT_CONFIG/config" -s "$CURRENT_CONFIG/style.css" &
