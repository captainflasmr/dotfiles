import os
import subprocess

from libqtile import bar, hook, layout, widget, qtile, bar, widget
from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.lazy import lazy
from libqtile.widget import TextBox

from libqtile.utils import guess_terminal

mod = "mod4"
terminal = guess_terminal()

# Define keybindings
keys = [
    # -> keys
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +2%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 2%-")),

    # -> programs
    Key([mod], "e", lazy.spawn("thunar")),
    Key([mod], "c", lazy.spawn("emacs")),
    Key([mod], "g", lazy.spawn("gthumb")),
    Key([mod], "m", lazy.spawn("thunderbird")),
    Key([mod], "w", lazy.spawn("flatpak run com.microsoft.Edge")),
    Key([mod, "shift"], "p", lazy.spawn("pamac-manager")),
    Key([mod], "p", lazy.spawn("keepassxc")),
    Key([mod], "Return", lazy.spawn("gnome-terminal")),
    Key(["control", "mod1"], "t", lazy.spawn("gnome-terminal")),
    Key([mod], "d", lazy.spawn("dmenu_run -fn 'Mono:pixelsize=22'")),
    Key(["mod1"], "space", lazy.spawn("rofi -show drun")),

    Key([mod, "shift"], "w", lazy.spawn("wallpaper_updatewal-styli.sh")),
    Key([mod, "shift"], "s", lazy.spawn("screenshot_x11.sh")),

    # -> Moving around
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.up()),
    Key([mod], "k", lazy.layout.down()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Down", lazy.layout.down()),
    Key(["control", "mod1"], "o", lazy.layout.left()),

    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),

    # Toggle between different layouts
    Key([mod], "Tab", lazy.next_layout()),

    # Close a window
    Key([mod, "shift"], "q", lazy.window.kill()),
    Key(["mod1"], "f4", lazy.window.kill()),

    # Restart and quit qtile
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "c", lazy.restart()),
    # Key([mod, "shift"], "e", lazy.shutdown()),

    # workspaces
    Key(["control", "mod1"], "l", lazy.screen.next_group()),
    Key(["control", "mod1"], "h", lazy.screen.prev_group()),

    # Resize windows
    Key(["control", "mod1"], "u", lazy.layout.grow_left()),
    Key(["control", "mod1"], "i", lazy.layout.grow_right())
]

groups = [Group(i) for i in "1234"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(grow_amount=5, margin=4, border_on_single=1, border_focus="#59717e", border_width=5, insert_position=1),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(margin=4, border_on_single=1, border_focus_stack="#d75f5f", border_width=6),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    layout.Tile(margin=4, border_on_single=1, border_focus_stack="#d75f5f", border_width=6),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
    # layout.Max(),
]

widget_defaults = dict(
    font='SourceCodePro Medium',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

search_paths = [
    # '/etc/xdg/autostart',
    os.path.expanduser('~/.config/autostart'),
    os.path.expanduser('~/.config/qtile/autostart'),
]

@hook.subscribe.startup_once
def autostart():
    # subprocess.run(['dex -a -s ~/.config/autostart:~/.config/qtile/autostart --environment qtile'])
    autostart_paths = ':'.join(search_paths)
    subprocess.run(['/usr/bin/dex', '-as', autostart_paths])

# Define startup script
# @hook.subscribe.startup_once
# def autostart():
#     home = os.path.expanduser('~/bin/startup.sh')
#     subprocess.run([home])

@hook.subscribe.client_new
def floating_applications(window):
    # Define the window class of the application
    if window.window.get_wm_class() == ("onboard", "Onboard"):
        window.floating = True

# Define floating layout
floating_layout = layout.Floating(border_focus='#000000')

# auto_fullscreen = True
# focus_on_window_activation = "smart"
# reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
