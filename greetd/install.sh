#!/bin/bash
# Install greetd + nwg-hello configs from this repo into /etc via symlinks.
#
#   sudo ./install.sh           # symlink configs into /etc (idempotent)
#   sudo ./install.sh --enable  # also unmask + enable greetd.service
#
# Needs root. Backs up any pre-existing regular files before symlinking.
# Re-run after editing the tracked configs to refresh (symlinks are live,
# so edits in the repo take effect immediately without re-running).
set -euo pipefail

SELF="$(readlink -f "$0")"
SRC="$(dirname "$SELF")"            # ~/.config/greetd
NWG_SRC="$SRC/nwg-hello"

GREETD_DST="/etc/greetd"
NWG_DST="/etc/nwg-hello"

if [[ $EUID -ne 0 ]]; then
    echo "Run with sudo: sudo $0 [--enable]" >&2
    exit 1
fi

# Back up a pre-existing regular file (not symlinks) before replacing it.
backup() {
    local f="$1"
    if [[ -e "$f" && ! -L "$f" ]]; then
        mv "$f" "$f.bak.$(date +%s)"
        echo "  backed up existing $f"
    fi
}

echo "Installing greetd + nwg-hello configs..."
mkdir -p "$GREETD_DST" "$NWG_DST"

# greetd reads /etc/greetd/config.toml (the canonical name).
backup "$GREETD_DST/config.toml"
ln -sfn "$SRC/config.toml" "$GREETD_DST/config.toml"
echo "  linked $GREETD_DST/config.toml -> $SRC/config.toml"

# nwg-hello reads /etc/nwg-hello/{sway-config,nwg-hello.json,nwg-hello.css}.
for f in sway-config nwg-hello.json nwg-hello.css; do
    backup "$NWG_DST/$f"
    ln -sfn "$NWG_SRC/$f" "$NWG_DST/$f"
    echo "  linked $NWG_DST/$f -> $NWG_SRC/$f"
done

# The greeter runs as the 'greeter' user; it needs the 'video' group for DRM/KMS.
if ! id greeter >/dev/null 2>&1; then
    echo "WARN: 'greeter' user does not exist on this system" >&2
elif ! id -nG greeter | grep -qw video; then
    usermod -aG video greeter
    echo "  added 'greeter' to the video group"
else
    echo "  OK: 'greeter' already in video group"
fi

# Symlinks point into the repo owner's home; the 'greeter' user must be able
# to traverse every directory along the path to follow them.
OWNER_UID="$(stat -c %u "$SRC")"
OWNER_HOME="$(getent passwd "$OWNER_UID" | cut -d: -f6)"
check_traverse() {
    local d="$1"
    if [[ -d "$d" ]] && [[ $(( $(stat -c %a "$d") & 001 )) -eq 0 ]]; then
        echo "WARN: $d is not traversable by others; the greeter cannot follow" \
             "symlinks into it. Fix: chmod o+x $d" >&2
    fi
}
if [[ -n "$OWNER_HOME" ]]; then
    check_traverse "$OWNER_HOME"
    check_traverse "$OWNER_HOME/.config"
    check_traverse "$SRC"
    check_traverse "$NWG_SRC"
fi

if [[ "${1:-}" == "--enable" ]]; then
    echo
    echo "Enabling greetd as the display manager..."
    systemctl unmask greetd
    systemctl enable greetd
    echo "  greetd unmasked + enabled. It will start on next boot."
    echo "  To test now (ends your current session!): sudo systemctl start greetd"
else
    echo
    echo "Configs installed. greetd.service is still masked."
    echo "To activate as the display manager:"
    echo "  sudo $0 --enable"
fi
