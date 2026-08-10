#!/bin/bash

# Dynamically scale waybar (font size, which drives bar height/width)
# Usage: waybar_scale.sh bigger|smaller

ACTION="${1:-bigger}"
STEP=1
MIN=8
MAX=24

CONFIG_FILE="$HOME/.config/waybar_active"
if [[ ! -f $CONFIG_FILE ]]; then
    echo "$HOME/.config/waybar" > "$CONFIG_FILE"
fi

DIR=$(cat "$CONFIG_FILE")
CSS="$DIR/style.css"

if [[ ! -f $CSS ]]; then
    echo "Error: $CSS not found" >&2
    exit 1
fi

case $ACTION in
    bigger|+) DIRECTION=1 ;;
    smaller|-) DIRECTION=-1 ;;
    *)
        echo "Usage: waybar_scale.sh bigger|smaller" >&2
        exit 1 ;;
esac

CURRENT=$(grep -oE 'font-size: *[0-9]+px' "$CSS" | head -1 | grep -oE '[0-9]+')
if [[ -z $CURRENT ]]; then
    echo "Error: no font-size found in $CSS" >&2
    exit 1
fi

NEW=$(( CURRENT + DIRECTION * STEP ))
if (( NEW < MIN )); then NEW=$MIN; fi
if (( NEW > MAX )); then NEW=$MAX; fi

if [[ $NEW -eq $CURRENT ]]; then
    echo "Waybar font size already at limit (${CURRENT}px)"
    exit 0
fi

sed -i -E "s/font-size: *[0-9]+px/font-size: ${NEW}px/g" "$CSS"

killall waybar 2>/dev/null
waybar -c "$DIR/config" -s "$CSS" &

echo "Waybar font size: ${CURRENT}px -> ${NEW}px"
