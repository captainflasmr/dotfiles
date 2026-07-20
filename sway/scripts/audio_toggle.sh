#!/bin/bash
# Toggle audio output between laptop Speaker and Headphones.
# This SOF/HDA card exposes them as separate UCM profiles rather than
# auto-switching ports, so plugging in a jack does nothing on its own.

CARD=$(pactl list cards short | awk '/skl_hda_dsp_generic/ {print $2}' | head -1)
SPEAKER="HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)"
HEADPHONES="HiFi (HDMI1, HDMI2, HDMI3, Headphones, Mic1, Mic2)"

if pactl list cards | grep -q "Active Profile: $HEADPHONES"; then
    pactl set-card-profile "$CARD" "$SPEAKER"
    notify-send -t 1500 "Audio" "Speaker" 2>/dev/null
else
    pactl set-card-profile "$CARD" "$HEADPHONES"
    notify-send -t 1500 "Audio" "Headphones" 2>/dev/null
fi
