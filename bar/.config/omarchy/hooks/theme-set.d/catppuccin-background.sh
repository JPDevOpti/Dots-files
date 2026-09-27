#!/bin/bash
# Pin the Catppuccin wallpaper: re-apply it whenever the theme is (re)applied.
THEME_NAME="$1"
BACKGROUND="$HOME/.config/omarchy/backgrounds/catppuccin/0-japon-lago.jpg"

if [[ "${THEME_NAME,,}" == "catppuccin" && -f "$BACKGROUND" ]]; then
  omarchy-theme-bg-set "$BACKGROUND"
fi
