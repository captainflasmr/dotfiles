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
    sed -i 's|.*"width":.*|    "width": 100,|' "$CURRENT_CONFIG/config"
    if ! grep -q '"width"' "$CURRENT_CONFIG/config"; then
        sed -i '/"position"/a\    "width": 100,' "$CURRENT_CONFIG/config"
    fi
    # Show short app_id instead of full title in narrow sidebar
    sed -i '/"sway\/window"/,/format/s/"format": "{}"/"format": "{app_id}"/' "$CURRENT_CONFIG/config"
else
    sed -i 's|.*"width":.*|    \/\/ "width": 100,|' "$CURRENT_CONFIG/config"
    sed -i '/"sway\/window"/,/format/s/"format": "{app_id}"/"format": "{}"/' "$CURRENT_CONFIG/config"
fi

# Create visible gap at bottom by pushing bar up from edge
if [[ $POSITION == "bottom" ]]; then
    swaymsg gaps bottom all set 10
    sed -i 's|"margin-bottom": [0-9-]*|"margin-bottom": 15|' "$CURRENT_CONFIG/config"
    sed -i 's|"margin-top": [0-9-]*|"margin-top": 4|' "$CURRENT_CONFIG/config"
    grep -q 'margin-bottom' "$CURRENT_CONFIG/config" || \
        sed -i '/"position"/a\    "margin-bottom": 15,' "$CURRENT_CONFIG/config"
else
    swaymsg gaps bottom all set 0
    sed -i 's|"margin-bottom": [0-9-]*|"margin-bottom": -10|' "$CURRENT_CONFIG/config"
    sed -i 's|"margin-top": [0-9-]*|"margin-top": 4|' "$CURRENT_CONFIG/config"
fi

# Restart waybar
killall waybar 2>/dev/null
waybar -c "$CURRENT_CONFIG/config" -s "$CURRENT_CONFIG/style.css" &
