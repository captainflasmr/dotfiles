#!/bin/bash

# Dynamically scale waybar (font size, which drives bar height/width).
# Module padding/margin are em-based in style.css so they scale automatically;
# fixed pixel values in config/modules.json (spacing, margins, tray icon size)
# are rescaled here.
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
BASE_CSS="$DIR/style.css"
THEME_CSS="$DIR/style.theme.css"

# The bar runs with style.theme.css when theme-switch has generated one;
# otherwise it runs with style.css. Scale whichever file is actually in use.
CSS="$BASE_CSS"
[[ -f $THEME_CSS ]] && CSS="$THEME_CSS"

if [[ ! -f $CSS ]]; then
    echo "Error: $CSS not found" >&2
    exit 1
fi

# Rescale pixel values (spacing, margins, tray icon size) in a JSON config so
# fixed-size geometry shrinks/grows by the same ratio as the font.
scale_config() {
    local file=$1
    [[ -f $file ]] || return 0

    NEW="$NEW" CURRENT="$CURRENT" perl -0pi -e '
        my $ratio = $ENV{NEW} / $ENV{CURRENT};
        s{("(?:icon-size|icon-spacing|spacing|margin-top|margin-bottom|margin-right|margin-left)"\s*:\s*)(-?\d+)}{
            my $v = $2 * $ratio;
            $1 . ($v >= 0 ? int($v + 0.5) : -int(-$v + 0.5));
        }ge;
    ' "$file"
}

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

# Keep the base stylesheet and the generated themed copy in sync. Otherwise a
# later theme switch (Mod4+F3) would regenerate style.theme.css from a stale
# style.css and undo the scale change.
for file in "$BASE_CSS" "$THEME_CSS"; do
    [[ -f $file ]] || continue
    sed -i -E "s/font-size: *[0-9]+px/font-size: ${NEW}px/g" "$file"
done

scale_config "$DIR/config"
scale_config "$DIR/modules.json"

if [[ -x "$HOME/bin/launch_waybar" ]]; then
    "$HOME/bin/launch_waybar"
else
    killall waybar 2>/dev/null
    waybar -c "$DIR/config" -s "$CSS" &
fi

echo "Waybar font size: ${CURRENT}px -> ${NEW}px"
