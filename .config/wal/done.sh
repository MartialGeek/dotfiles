#!/bin/sh

# ===================
# ====== bspwm ======
# ===================

# Source the colors from wal
source "${HOME}/.cache/wal/colors.sh"

bspc config normal_border_color "$color1"
bspc config active_border_color "$color2"
bspc config focused_border_color "$color15"
bspc config presel_feedback_color "$color1"

mkdir -p  "${HOME}/.config/dunst"
ln -sf "${HOME}/.cache/wal/dunstrc" "${HOME}/.config/dunst/dunstrc"
pkill dunst
dunst &

