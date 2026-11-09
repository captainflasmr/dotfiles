#!/usr/bin/env bash
# Move the focused tiled window one slot in a screen-relative direction.
#
# `move left|right|up|down` follows the container tree, which is confusing
# when the layout is nested.  Instead, find the visible tiled window nearest
# to the focused one in the requested direction on screen and swap places
# with it.  Falls back to sway's built-in move when there is no neighbour
# (e.g. at the edge of an output) or when the focused window is floating.
#
# Usage: move_dir.sh left|right|up|down

set -euo pipefail

dir=${1:?usage: $0 left|right|up|down}
case "$dir" in
    left|right|up|down) ;;
    *) echo "move_dir.sh: unknown direction: $dir" >&2; exit 2 ;;
esac

tree=$(swaymsg -t get_tree)

# One tab-separated row per window:
#   focused  id  x  y  w  h  floating  workspace
rows=$(
    jq -r '
        def leaf:
            .type == "con"
            and ((.nodes // []) | length == 0)
            and ((.floating_nodes // []) | length == 0)
            and .pid != null;
        def row($floating; $ws):
            [ (if .focused then 1 else 0 end), .id,
              .rect.x, .rect.y, .rect.width, .rect.height,
              $floating, $ws ] | @tsv;
        .. | objects
        | select(.type == "workspace")
        | .name as $ws
        | ( (.nodes // [])[] | .. | objects | select(leaf) | row(0; $ws) ),
          ( (.floating_nodes // [])[] | .. | objects | select(leaf) | row(1; $ws) )
    ' <<<"$tree"
)

focused=$(awk -F'\t' '$1 == 1 { print; exit }' <<<"$rows")
[[ -n "$focused" ]] || exit 0

IFS=$'\t' read -r _ f_id f_x f_y f_w f_h f_floating f_ws <<<"$focused"

# Floating windows are dragged with the mouse; keep sway's own semantics.
if [[ "$f_floating" != 0 ]]; then
    swaymsg move "$dir"
    exit 0
fi

# Pick the nearest tiled window on the same workspace whose rect lies in the
# requested direction.  Windows overlapping the perpendicular axis win over
# diagonal ones; ties are broken by centre-line distance.
target=$(
    awk -F'\t' -v dir="$dir" \
        -v fx="$f_x" -v fy="$f_y" -v fw="$f_w" -v fh="$f_h" \
        -v ws="$f_ws" '
        function min(a, b) { return a < b ? a : b }
        function max(a, b) { return a > b ? a : b }
        $1 == 1 { next }        # the focused window itself
        $7 != 0 { next }        # floating windows are not swap targets
        $8 != ws { next }       # other workspaces are out of reach
        {
            x = $3 + 0; y = $4 + 0; w = $5 + 0; h = $6 + 0
            gap = 0

            if (dir == "left") {
                if (x + w > fx + 2) next
                gap = fx - (x + w)
            } else if (dir == "right") {
                if (x < fx + fw - 2) next
                gap = x - (fx + fw)
            } else if (dir == "up") {
                if (y + h > fy + 2) next
                gap = fy - (y + h)
            } else {            # down
                if (y < fy + fh - 2) next
                gap = y - (fy + fh)
            }
            if (gap < 0) gap = 0

            if (dir == "left" || dir == "right") {
                overlap = min(y + h, fy + fh) - max(y, fy)
                perp = (y + h / 2) - (fy + fh / 2)
            } else {
                overlap = min(x + w, fx + fw) - max(x, fx)
                perp = (x + w / 2) - (fx + fw / 2)
            }
            if (perp < 0) perp = -perp

            if (overlap > 0 &&
                (best_ov == "" || gap < bgap_ov ||
                 (gap == bgap_ov && perp < bperp_ov))) {
                best_ov = $2; bgap_ov = gap; bperp_ov = perp
            }
            if (best_any == "" || gap < bgap_any ||
                (gap == bgap_any && perp < bperp_any)) {
                best_any = $2; bgap_any = gap; bperp_any = perp
            }
        }
        END {
            if (best_ov != "") print best_ov
            else if (best_any != "") print best_any
        }
    ' <<<"$rows"
)

# No neighbour in that direction: let sway's built-in move handle edge cases
# (such as moving the window to the next output).
if [[ -z "$target" ]]; then
    swaymsg move "$dir"
    exit 0
fi

swaymsg swap container with con_id "$target"
