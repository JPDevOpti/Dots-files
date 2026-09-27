#!/bin/bash
# Home layout (Super+D):
#   DP-1/DP-3 -> top-left      (0x0)  (whichever connector the Lenovo is on)
#   HDMI-A-1  -> top-right     (1920x0)
#   eDP-2     -> bottom center (960x1080), primary panel
#
# Hyprland runs the Lua config parser here, so `hyprctl keyword` is rejected
# ("keyword can't work with non-legacy parsers"). `hyprctl eval` runs the same
# hl.* API the config uses, which is the supported runtime path.
#
# The externals are cycled through disabled=true first on purpose. An output
# that came up as a mirror is never advertised to Wayland clients as its own
# wl_output, so omarchy-shell draws no bar and no wallpaper on it, and simply
# clearing the mirror does not bring the output back. Disabling and
# re-enabling forces Hyprland to recreate the output global.

eval_hl() { hyprctl eval "hl.monitor({ $1 })" | grep -q '^ok'; }

# Top-left Lenovo: DP-1 (NVIDIA) or DP-3 (amdgpu), depending on the port in use.
dp=$(hyprctl monitors all -j | jq -r '.[] | select(.name == "DP-1" or .name == "DP-3") | .name' | head -n1)
dp=${dp:-DP-1}

eval_hl "output = \"$dp\", disabled = true"
eval_hl 'output = "HDMI-A-1", disabled = true'
sleep 1

# mirror = "" is required: re-enabling an output without it keeps the mirror
# it inherited from the catch-all rule in monitors.lua.
failed=()
eval_hl "output = \"$dp\",     mode = \"1920x1080@60.00\",  position = \"0x0\",      scale = 1, mirror = \"\", disabled = false" || failed+=("$dp")
eval_hl 'output = "HDMI-A-1", mode = "1920x1080@60.00",  position = "1920x0",   scale = 1, mirror = "", disabled = false' || failed+=(HDMI-A-1)
eval_hl 'output = "eDP-2",    mode = "1920x1200@144.00", position = "960x1080", scale = 1, mirror = "", disabled = false' || failed+=(eDP-2)

if ((${#failed[@]})); then
  omarchy-notification-send "Monitors" "Could not apply home layout: ${failed[*]}"
  exit 1
fi

# Workspace rules only apply to workspaces created after the rule; existing
# ones stay where the hotplug left them. Pin the three main ones explicitly.
sleep 1
move_ws() { hyprctl dispatch "hl.dsp.workspace.move({ workspace = \"$1\", monitor = \"$2\" })" >/dev/null; }
move_ws 1 eDP-2
move_ws 2 "$dp"
move_ws 3 HDMI-A-1

# Restart the Omarchy shell so bar and wallpaper cover every monitor
omarchy-restart-shell
