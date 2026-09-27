-- Personal keybindings, ported from the pre-4.x bindings.conf.
-- See current bindings: omarchy menu keybindings --print

-- Unbind safely even when the key is not bound by the defaults.
local function unbind(key)
  pcall(hl.unbind, key)
end

-- ── Release default bindings that are reassigned below ─────────────────────
unbind("SUPER + W")             -- was: Close window        → Browser
unbind("SUPER + S")             -- was: Toggle scratchpad   → Screenshot region
unbind("SUPER + X")             -- was: Universal cut       → Full screen
unbind("SUPER + C")             -- was: Universal copy      → Pop out
unbind("SUPER + V")             -- was: Universal paste     → Toggle split
unbind("SUPER + O")             -- was: Pop out             → moved to SUPER + C
unbind("SUPER + J")             -- was: Toggle split        → moved to SUPER + V
unbind("SUPER + L")             -- was: Toggle layout       → moved to SUPER + B
unbind("SUPER + SHIFT + D")     -- was: Docker
unbind("SUPER + RETURN")        -- was: Terminal            → Reload Hyprland + shell + monitors
unbind("SUPER + SHIFT + RETURN")-- was: Browser             → Reload Hyprland
unbind("SUPER + SHIFT + W")
unbind("SUPER + SHIFT + M")
unbind("SUPER + SHIFT + O")
unbind("SUPER + SHIFT + SLASH")
unbind("SUPER + SHIFT + I")

-- ── Windows ─────────────────────────────────────────────────────────────────
o.bind("SUPER + X", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + C", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")
o.bind("SUPER + V", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + B", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + Z", "Close window", hl.dsp.window.close())

-- ── Horizontal scroll wheel navigation (Logitech MX Master 3S) ──────────────
-- Falls back to the original relative-workspace dispatcher when the
-- dofustabs module is not loaded (or was uninstalled). Resolved at call
-- time, not at load time, since bindings.lua may load before dofustabs.lua.
local function desktop_scroll_step(delta)
  return function()
    if _G.dofustabs and _G.dofustabs.desktop_step then
      _G.dofustabs.desktop_step(delta)
    else
      hl.dispatch(hl.dsp.focus({ workspace = delta > 0 and "e+1" or "e-1" }))
    end
  end
end

o.bind("mouse_right", "Next workspace (horizontal scroll)", desktop_scroll_step(1))
o.bind("mouse_left", "Previous workspace (horizontal scroll)", desktop_scroll_step(-1))

-- ── Capture and visual tools ────────────────────────────────────────────────
o.bind("SUPER + S", "Screenshot region to clipboard", "omarchy-capture-screenshot region copy")
o.bind("SUPER + A", "Color picker to clipboard", "pkill hyprpicker || hyprpicker -a")

-- ── Main apps ───────────────────────────────────────────────────────────────
o.bind("SUPER + Q", "Terminal (home)", { launch = "alacritty --working-directory " .. os.getenv("HOME") })
o.bind("SUPER + SHIFT + Q", "Terminal + Tmux", o.launch('xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "tmux attach || tmux new -s Work"'))
o.bind("SUPER + W", "Browser", { omarchy = "browser" })
o.bind("SUPER + SHIFT + W", "Browser (private)", { omarchy = "browser --private" })
o.bind("SUPER + R", "Editor (Zed)", { launch = "zed" })
o.bind("SUPER + E", "File manager (Thunar)", { launch = "thunar" })
o.bind("SUPER + ALT + E", "File manager (cwd)", o.launch('thunar "$(omarchy-cmd-terminal-cwd)"'))

-- ── Launcher ────────────────────────────────────────────────────────────────
unbind("SUPER + SPACE")         -- was: Omarchy menu       → Apps menu
o.bind("SUPER + SPACE", "Apps menu", "omarchy-menu toggle apps")

-- ── Secondary apps ──────────────────────────────────────────────────────────
o.bind("SUPER + SHIFT + M", "Music (Spotify)", "omarchy-launch-or-focus spotify")
o.bind("SUPER + D", "Monitors (home layout)", os.getenv("HOME") .. "/.config/hypr/scripts/monitors-home.sh")
o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })
o.bind("SUPER + SHIFT + SLASH", "Passwords", { launch = "1password" })
o.bind("SUPER + SHIFT + I", "Claude (AI)", o.launch('xdg-terminal-exec bash -c "claude"'))
o.bind("SUPER + SHIFT + RETURN", "Reload Hyprland", "hyprctl reload")
o.bind("SUPER + RETURN", "Reload Hyprland + shell + monitors", "hyprctl reload && " .. os.getenv("HOME") .. "/.config/hypr/scripts/monitors-home.sh && omarchy-restart-shell")

