-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

-- Window borders: neutral tones that read on a light wallpaper instead of the
-- theme's neon blue accent. Loaded after the theme, so this wins.
local active_border_color = "#ffffff"
local inactive_border_color = "rgba(7f7f7f99)"

hl.config({
  general = {
    border_size = 0,
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },
  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
  },
  decoration = {
    rounding = 0,
  },
})

-- >>> omaland managed block >>>
-- Written by Omaland. Safe to hand-edit: Omaland re-reads this block
-- every time it opens, and only ever rewrites what's between the fences.
hl.config({
  decoration = {
    border_part_of_window = true,
    dim_around = 0.4,
    dim_inactive = false,
    dim_special = 0.19,
    rounding = 0,
    rounding_power = 2.2,

    blur = {
      enabled = true,
    },

    glow = {
      enabled = false,
      range = 3,
      render_power = 4,
    },

    shadow = {
      enabled = true,
      range = 6,
      render_power = 2,
    },
  },

  general = {
    border_size = 0,
    float_gaps = 10,
    gaps_in = 10,
    gaps_out = 14,
    gaps_workspaces = 0,
    layout = "dwindle",

    snap = {
      enabled = true,
    },
  },

  group = {
    groupbar = {
      disable_when_only = true,
      stacked = true,
    },
  },

  master = {
    mfact = 0.46,
  },
})
-- <<< omaland managed block <<<

-- Global opacity: focused window fully opaque, unfocused windows at 0.85.
-- Declared last so it overrides Omarchy default and per-app opacity rules.
o.window(".*", { tag = "-default-opacity", opacity = "1.0 0.85" })

-- Zen Browser: always fully opaque, focused or not. Declared after the global
-- rule so it wins for this class only.
o.window("^(zen)$", { opacity = "1.0 1.0" })

-- Keep the cursor where it is when switching workspaces (Omarchy default
-- warps it to the last active window of the target workspace), and keep it
-- visible after a key press (Omarchy default hides it until the mouse moves,
-- which made it vanish on every F1/F2 switch and in-game shortcut).
hl.config({ cursor = { warp_on_change_workspace = 0, hide_on_key_press = false } })
