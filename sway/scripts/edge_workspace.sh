#!/usr/bin/env bash
# Switch workspace at a screen edge, then warp the pointer to the opposite
# edge so continued movement in the same direction keeps crossing desktops.
#
# Usage: edge_workspace.sh left|right
# Called from ~/.config/waybound/waybound.toml.

set -euo pipefail

dir=${1:?usage: $0 left|right}

case "$dir" in
    left)  ws_cmd=prev_on_output ;;
    right) ws_cmd=next_on_output ;;
    *)     echo "edge_workspace: unknown direction: $dir" >&2; exit 2 ;;
esac

current=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .name')
swaymsg -q workspace "$ws_cmd"
after=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .name')

# Only wrap the pointer if we actually moved to another workspace.
[[ "$current" == "$after" ]] && exit 0

# Width of the output whose workspace just changed.
read -r ow < <(
    swaymsg -t get_outputs |
        jq -r '.[] | select(.focused) | .rect.width'
)

# Land just outside the opposite waybound strip.  Read its thickness from
# the config so changing `size` there doesn't make the warp land inside the
# strip (which would immediately trigger the opposite edge).
wb_config=${WAYBOUND_CONFIG:-$HOME/.config/waybound/waybound.toml}
strip=$(sed -n 's/^[[:space:]]*size[[:space:]]*=[[:space:]]*\([0-9][0-9]*\).*/\1/p' "$wb_config" 2>/dev/null | head -n1 || true)
strip=${strip:-3}

# Relative movement keeps the pointer's Y coordinate.  (Using
# `cursor set X 0` resets Y to the top of the screen on this sway build.)
travel=$((ow - 2 * strip - 2))
if [[ "$dir" == left ]]; then
    dx=$travel
else
    dx=$((-travel))
fi

swaymsg -q -- seat - cursor move "$dx" 0
