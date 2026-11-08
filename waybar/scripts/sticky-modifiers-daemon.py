#!/usr/bin/env python3
"""Publish latched/locked XKB modifier state for Waybar.

Sway does not expose the seat's active modifier state over IPC, so this daemon
reads the main keyboard device directly from evdev and replays its events
through libxkbcommon using the same XKB keymap that sway loads.  The resulting
state therefore matches the compositor's sticky-modifier state exactly.

The state is written as Waybar custom-module JSON to
$XDG_RUNTIME_DIR/waybar-sticky-modifiers.json.  Waybar is poked with
SIGRTMIN+2 whenever the visible state changes (the waybar module uses
"signal": 2).

The daemon follows the keyboard selected by ~/bin/keyboard-reset.sh:
the USB SEMICO keyboard when it is plugged in, otherwise the internal
AT keyboard.  It also reloads its keymap when sway reports an xkb_keymap
change (or when the keymap file changes on disk).
"""

from __future__ import annotations

import argparse
import ctypes
import ctypes.util
import fcntl
import json
import os
import re
import select
import signal
import socket
import struct
import subprocess
import sys
import threading
import time
from pathlib import Path

HOME = Path.home()
DEFAULT_WAYBAR_SIGNAL = 2  # waybar config uses "signal": 2

# evdev <-> xkbcommon
LINUX_KEYCODE_OFFSET = 8
EV_KEY = 1
EVENT_STRUCT = struct.Struct("@llHHi")  # native long/input_event layout
EVENT_SIZE = EVENT_STRUCT.size
XKB_KEY_UP = 0
XKB_KEY_DOWN = 1
XKB_KEYMAP_FORMAT_TEXT_V1 = 1
XKB_KEYMAP_COMPILE_NO_FLAGS = 0
XKB_STATE_MODS_LATCHED = 1 << 1
XKB_STATE_MODS_LOCKED = 1 << 2

# Keyboards in priority order.  These mirror keyboard-reset.sh / startup.sh.
PREFERRED_DEVICE_LINKS = [
    "/dev/input/by-id/usb-SEMICO_USB_Gaming_Keyboard-event-kbd",
]
FALLBACK_DEVICE_NAMES = [
    "SEMICO USB Gaming Keyboard",
    "AT Translated Set 2 keyboard",
]

# Real and virtual modifier names to display.  Virtual names are checked first
# so that "Alt"/"Super" are shown instead of their underlying Mod1/Mod4.
MOD_LABELS = (
    ("Shift", "Shift"),
    ("Control", "Ctrl"),
    ("Alt", "Alt"),
    ("Mod1", "Alt"),
    ("Super", "Super"),
    ("Mod4", "Super"),
    ("Hyper", "Hyper"),
    ("Mod3", "Hyper"),
    ("LevelThree", "AltGr"),
    ("LevelFive", "AltGr"),
    ("Mod5", "AltGr"),
    ("NumLock", "Num"),
    ("Mod2", "Num"),
    ("Lock", "Caps"),
)

IDLE_ICON = "\U000f030c"   # nf-md-keyboard
LOCK_ICON = "\U000f033e"   # nf-md-lock
COLOR_LATCHED = "#ebcb8b"  # nord13
COLOR_LOCKED = "#bf616a"   # nord11
COLOR_IDLE = "#4c566a"     # nord3

SWAY_INPUT_EVENT = 0x80000015


def log(message: str) -> None:
    print(f"[sticky-mods] {message}", file=sys.stderr, flush=True)


def default_state_path() -> Path:
    runtime = os.environ.get("XDG_RUNTIME_DIR")
    if runtime and os.path.isdir(runtime) and os.access(runtime, os.W_OK):
        return Path(runtime) / "waybar-sticky-modifiers.json"
    return Path("/tmp") / "waybar-sticky-modifiers.json"


def find_sway_keymap() -> Path | None:
    """Find the xkb_file referenced by the current sway configuration."""
    config_dir = HOME / ".config" / "sway"
    candidates = [config_dir / "config"]
    config_d = config_dir / "config.d"
    if config_d.is_dir():
        candidates.extend(sorted(p for p in config_d.iterdir() if p.is_file()))

    for path in candidates:
        try:
            text = path.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        for line in text.splitlines():
            line = line.split("#", 1)[0].strip()
            match = re.match(r"xkb_file\s+(.+)$", line)
            if not match:
                continue
            value = match.group(1).strip().strip("'\"")
            value = os.path.expanduser(os.path.expandvars(value))
            if os.path.isfile(value):
                return Path(value)

    for fallback in (
        HOME / ".emacs.d" / "keymap_with_sticky_modifiers.xkb",
        HOME / ".config" / "keymap_sway.xkb",
        HOME / ".config" / "keymap_with_sticky_modifiers.xkb",
        HOME / ".config" / "keymap_with_locked_modifiers.xkb",
    ):
        if fallback.is_file():
            return fallback
    return None


def _event_node_for_name(name: str) -> str | None:
    try:
        blocks = Path("/proc/bus/input/devices").read_text(errors="replace").split("\n\n")
    except OSError:
        return None

    target = " ".join(name.split())
    for block in blocks:
        match = re.search(r'^N: Name="(.*)"$', block, re.MULTILINE)
        if not match or " ".join(match.group(1).split()) != target:
            continue
        for line in block.splitlines():
            if not line.startswith("H: Handlers="):
                continue
            for token in line.split("=", 1)[1].split():
                if re.fullmatch(r"event\d+", token):
                    path = f"/dev/input/{token}"
                    if os.path.exists(path):
                        return path
    return None


def find_keyboard_device() -> str | None:
    for link in PREFERRED_DEVICE_LINKS:
        if os.path.exists(link):
            return os.path.realpath(link)
    for name in FALLBACK_DEVICE_NAMES:
        path = _event_node_for_name(name)
        if path:
            return path
    return None


class Xkb:
    """A libxkbcommon keymap + state, mirroring sway's keyboard state."""

    def __init__(self) -> None:
        library = ctypes.util.find_library("xkbcommon") or "libxkbcommon.so.0"
        self.lib = ctypes.CDLL(library)
        self._declare_prototypes()
        self.ctx = self.lib.xkb_context_new(0)
        if not self.ctx:
            raise RuntimeError("xkb_context_new failed")
        self.keymap = None
        self.state = None
        self.path: Path | None = None

    def _declare_prototypes(self) -> None:
        lib = self.lib
        ptr = ctypes.c_void_p
        lib.xkb_context_new.restype = ptr
        lib.xkb_context_new.argtypes = [ctypes.c_int]
        lib.xkb_keymap_new_from_string.restype = ptr
        lib.xkb_keymap_new_from_string.argtypes = [
            ptr,
            ctypes.c_char_p,
            ctypes.c_int,
            ctypes.c_int,
        ]
        lib.xkb_keymap_unref.restype = None
        lib.xkb_keymap_unref.argtypes = [ptr]
        lib.xkb_state_new.restype = ptr
        lib.xkb_state_new.argtypes = [ptr]
        lib.xkb_state_unref.restype = None
        lib.xkb_state_unref.argtypes = [ptr]
        lib.xkb_state_update_key.restype = ctypes.c_int
        lib.xkb_state_update_key.argtypes = [ptr, ctypes.c_uint32, ctypes.c_int]
        lib.xkb_state_mod_name_is_active.restype = ctypes.c_int
        lib.xkb_state_mod_name_is_active.argtypes = [ptr, ctypes.c_char_p, ctypes.c_int]

    def load(self, path: Path) -> None:
        data = path.read_bytes()
        keymap = self.lib.xkb_keymap_new_from_string(
            self.ctx, data, XKB_KEYMAP_FORMAT_TEXT_V1, XKB_KEYMAP_COMPILE_NO_FLAGS
        )
        if not keymap:
            raise RuntimeError(f"cannot compile keymap: {path}")
        state = self.lib.xkb_state_new(keymap)
        if not state:
            self.lib.xkb_keymap_unref(keymap)
            raise RuntimeError(f"cannot create xkb state for {path}")

        if self.state:
            self.lib.xkb_state_unref(self.state)
        if self.keymap:
            self.lib.xkb_keymap_unref(self.keymap)
        self.keymap = keymap
        self.state = state
        self.path = path

    def reset(self) -> None:
        if not self.keymap:
            return
        state = self.lib.xkb_state_new(self.keymap)
        if not state:
            return
        if self.state:
            self.lib.xkb_state_unref(self.state)
        self.state = state

    def update_key(self, evdev_code: int, pressed: bool) -> None:
        if not self.state or evdev_code <= 0:
            return
        direction = XKB_KEY_DOWN if pressed else XKB_KEY_UP
        self.lib.xkb_state_update_key(
            self.state, evdev_code + LINUX_KEYCODE_OFFSET, direction
        )

    def active_modifiers(self) -> list[tuple[str, str]]:
        """Return [(label, 'latched'|'locked'), ...] in display order."""
        if not self.state:
            return []

        states: dict[str, str] = {}
        for name, label in MOD_LABELS:
            encoded = name.encode()
            latched = self.lib.xkb_state_mod_name_is_active(
                self.state, encoded, XKB_STATE_MODS_LATCHED
            )
            locked = self.lib.xkb_state_mod_name_is_active(
                self.state, encoded, XKB_STATE_MODS_LOCKED
            )
            if locked:
                states[label] = "locked"
            elif latched and label not in states:
                states[label] = "latched"
        return list(states.items())


def build_payload(modifiers: list[tuple[str, str]], error: str | None = None) -> dict:
    if error:
        return {
            "text": f"<span foreground='{COLOR_LOCKED}'>?</span>",
            "tooltip": f"Sticky modifier indicator error:\n{error}",
            "class": "error",
        }

    if not modifiers:
        return {
            "text": f"<span foreground='{COLOR_IDLE}'>{IDLE_ICON}</span>",
            "tooltip": "Sticky modifiers: none\n\nTap Shift or Ctrl to latch a modifier.",
            "class": "idle",
        }

    parts = []
    lines = ["Sticky modifiers:"]
    any_locked = False
    for label, state in modifiers:
        if state == "locked":
            any_locked = True
            parts.append(
                f"<span foreground='{COLOR_LOCKED}' weight='bold'>{LOCK_ICON}{label}</span>"
            )
            lines.append(f"  {label}: locked")
        else:
            parts.append(f"<span foreground='{COLOR_LATCHED}'>{label}</span>")
            lines.append(f"  {label}: latched (one-shot)")

    lines.extend(("", "Tap a modifier again to clear or lock it."))
    return {
        "text": " ".join(parts),
        "tooltip": "\n".join(lines),
        "class": "locked" if any_locked else "latched",
    }


class SwayKeymapWatcher(threading.Thread):
    """Watch sway IPC input events and ask the daemon to reload on keymap change."""

    def __init__(self, on_keymap_change, stop_event: threading.Event) -> None:
        super().__init__(name="sway-ipc", daemon=True)
        self.on_keymap_change = on_keymap_change
        self.stop_event = stop_event

    def run(self) -> None:
        socket_path = os.environ.get("SWAYSOCK")
        if not socket_path:
            return

        while not self.stop_event.is_set():
            try:
                with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
                    sock.settimeout(1.0)
                    sock.connect(socket_path)
                    payload = b'["input"]'
                    header = b"i3-ipc" + struct.pack("=II", len(payload), 2)
                    sock.sendall(header + payload)

                    while not self.stop_event.is_set():
                        msg = self._recv_exact(sock, 14)
                        if msg is None or msg[:6] != b"i3-ipc":
                            break
                        length, msg_type = struct.unpack("=II", msg[6:])
                        data = self._recv_exact(sock, length)
                        if data is None:
                            break
                        if msg_type != SWAY_INPUT_EVENT:
                            continue
                        try:
                            event = json.loads(data)
                        except ValueError:
                            continue
                        if event.get("change") == "xkb_keymap":
                            self.on_keymap_change()
            except (OSError, socket.timeout):
                pass
            except Exception as exc:  # never take the daemon down
                log(f"sway IPC watcher: {exc}")
            self.stop_event.wait(2.0)

    def _recv_exact(self, sock: socket.socket, size: int) -> bytes | None:
        chunks = bytearray()
        while len(chunks) < size and not self.stop_event.is_set():
            try:
                chunk = sock.recv(size - len(chunks))
            except socket.timeout:
                continue
            if not chunk:
                return None
            chunks.extend(chunk)
        return bytes(chunks) if len(chunks) == size else None


class Publisher:
    def __init__(self, state_file: Path, signal_waybar: bool, waybar_signal: int):
        self.state_file = state_file
        self.signal_waybar = signal_waybar
        self.waybar_signal = waybar_signal
        self.last_payload: str | None = None

    def publish(self, payload: dict, force: bool = False) -> None:
        serialized = json.dumps(payload, ensure_ascii=False, separators=(",", ":"))
        if not force and serialized == self.last_payload:
            return

        try:
            self.state_file.parent.mkdir(parents=True, exist_ok=True)
            tmp = self.state_file.with_name(
                f".{self.state_file.name}.tmp.{os.getpid()}"
            )
            tmp.write_text(serialized + "\n", encoding="utf-8")
            os.chmod(tmp, 0o644)
            os.replace(tmp, self.state_file)
        except OSError as exc:
            log(f"cannot write {self.state_file}: {exc}")
            return

        self.last_payload = serialized
        if self.signal_waybar:
            self._poke_waybar()

    def _poke_waybar(self) -> None:
        try:
            subprocess.run(
                ["pkill", f"-RTMIN+{self.waybar_signal}", "-x", "waybar"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                check=False,
            )
        except OSError:
            pass


def acquire_lock(lock_file: Path) -> int | None:
    lock_file.parent.mkdir(parents=True, exist_ok=True)
    fd = os.open(lock_file, os.O_CREAT | os.O_RDWR, 0o600)
    try:
        fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
    except BlockingIOError:
        os.close(fd)
        return None
    return fd


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--device", help="evdev device (default: auto-detect main keyboard)")
    parser.add_argument("--keymap", help="XKB keymap file (default: from sway config)")
    parser.add_argument("--state", help="state JSON output path")
    parser.add_argument("--signal", type=int, default=DEFAULT_WAYBAR_SIGNAL,
                        help="Waybar signal offset (default: 2)")
    parser.add_argument("--no-signal", action="store_true", help="do not signal Waybar")
    parser.add_argument("--no-lock", action="store_true", help="do not use an instance lock")
    parser.add_argument("--verbose", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    state_file = Path(args.state).expanduser() if args.state else default_state_path()
    lock_file = state_file.with_name("waybar-sticky-modifiers.lock")

    lock_fd = None
    if not args.no_lock:
        lock_fd = acquire_lock(lock_file)
        if lock_fd is None:
            log("another instance is already running")
            return 0

    stop = threading.Event()
    reload_requested = threading.Event()

    def on_signal(signum, _frame):
        if signum == signal.SIGHUP:
            reload_requested.set()
        else:
            stop.set()

    signal.signal(signal.SIGTERM, on_signal)
    signal.signal(signal.SIGINT, on_signal)
    signal.signal(signal.SIGHUP, on_signal)

    xkb = Xkb()
    keymap_path: Path | None = None
    keymap_error: str | None = None

    def load_keymap(path: Path | None) -> bool:
        nonlocal keymap_path, keymap_error
        if path is None:
            keymap_error = "no keymap file found"
            return False
        try:
            xkb.load(path)
        except Exception as exc:
            keymap_error = str(exc)
            log(keymap_error)
            return False
        keymap_path = path
        keymap_error = None
        log(f"loaded keymap {path}")
        return True

    requested_keymap = Path(args.keymap).expanduser() if args.keymap else None
    if requested_keymap:
        load_keymap(requested_keymap)
    else:
        load_keymap(find_sway_keymap())

    publisher = Publisher(state_file, not args.no_signal, args.signal)
    publisher.publish(build_payload(xkb.active_modifiers(), keymap_error), force=True)

    if not requested_keymap:
        SwayKeymapWatcher(reload_requested.set, stop).start()

    device: str | None = args.device
    fd: int | None = None
    buffer = bytearray()
    next_device_check = 0.0
    next_keymap_check = 0.0
    keymap_mtime: int | None = None
    last_open_error: str | None = None

    if keymap_path:
        try:
            keymap_mtime = keymap_path.stat().st_mtime_ns
        except OSError:
            keymap_mtime = None

    while not stop.is_set():
        now = time.monotonic()

        if reload_requested.is_set():
            reload_requested.clear()
            new_path = requested_keymap or find_sway_keymap()
            if new_path:
                load_keymap(new_path)
            xkb.reset()
            buffer.clear()
            if keymap_path:
                try:
                    keymap_mtime = keymap_path.stat().st_mtime_ns
                except OSError:
                    keymap_mtime = None
            publisher.publish(
                build_payload(xkb.active_modifiers(), keymap_error), force=True
            )

        if keymap_path is None and now >= next_keymap_check:
            next_keymap_check = now + 5.0
            if load_keymap(requested_keymap or find_sway_keymap()):
                xkb.reset()
                buffer.clear()
                publisher.publish(
                    build_payload(xkb.active_modifiers(), keymap_error), force=True
                )

        if keymap_path and now >= next_keymap_check:
            next_keymap_check = now + 2.0
            try:
                mtime = keymap_path.stat().st_mtime_ns
            except OSError:
                mtime = None
            if mtime is not None and keymap_mtime is not None and mtime != keymap_mtime:
                log(f"keymap changed on disk: {keymap_path}")
                load_keymap(keymap_path)
                xkb.reset()
                buffer.clear()
                keymap_mtime = mtime
                publisher.publish(
                    build_payload(xkb.active_modifiers(), keymap_error), force=True
                )
            elif mtime is not None:
                keymap_mtime = mtime

        if not args.device and now >= next_device_check:
            next_device_check = now + 1.0
            found = find_keyboard_device()
            if found != device:
                device = found
                xkb.reset()
                buffer.clear()
                if fd is not None:
                    try:
                        os.close(fd)
                    except OSError:
                        pass
                    fd = None
                publisher.publish(
                    build_payload(xkb.active_modifiers(), keymap_error), force=True
                )
                if device:
                    log(f"using keyboard {device}")
                else:
                    log("no keyboard found, waiting")

        if fd is None:
            if not device:
                stop.wait(0.5)
                continue
            try:
                fd = os.open(device, os.O_RDONLY)
                last_open_error = None
                log(f"reading {device}")
            except OSError as exc:
                if str(exc) != last_open_error:
                    log(f"cannot open {device}: {exc}")
                    last_open_error = str(exc)
                stop.wait(0.5)
                continue

        try:
            readable, _, _ = select.select([fd], [], [], 0.5)
        except (OSError, ValueError):
            try:
                os.close(fd)
            except OSError:
                pass
            fd = None
            continue

        if not readable:
            continue

        try:
            data = os.read(fd, 8192)
        except OSError as exc:
            log(f"read error on {device}: {exc}")
            try:
                os.close(fd)
            except OSError:
                pass
            fd = None
            stop.wait(0.2)
            continue

        if not data:
            log(f"end of stream on {device}")
            try:
                os.close(fd)
            except OSError:
                pass
            fd = None
            continue

        buffer.extend(data)
        handled_key = False
        while len(buffer) >= EVENT_SIZE:
            _sec, _usec, ev_type, code, value = EVENT_STRUCT.unpack_from(buffer, 0)
            del buffer[:EVENT_SIZE]
            if ev_type == EV_KEY and value in (XKB_KEY_UP, XKB_KEY_DOWN):
                if args.verbose:
                    log(f"key code={code} {'down' if value else 'up'}")
                xkb.update_key(code, value == XKB_KEY_DOWN)
                handled_key = True

        if handled_key:
            publisher.publish(build_payload(xkb.active_modifiers(), keymap_error))

    if fd is not None:
        try:
            os.close(fd)
        except OSError:
            pass
    if lock_fd is not None:
        os.close(lock_fd)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except KeyboardInterrupt:
        raise SystemExit(0)
