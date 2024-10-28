local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.font = wezterm.font_with_fallback {
  'JetbrainsMono Nerd Font',
  'MartianMono Nerd Font',
}
-- General settings
config.color_scheme = "Tokyo Night Moon"
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.9
config.macos_window_background_blur = 90
config.bold_brightens_ansi_colors = true
config.font_size = 16
config.line_height = 1.3
config.window_decorations = "RESIZE"
config.window_padding = {
  bottom = 0,
  left = 4,
  right = 4,
  top = 0,
}
config.enable_wayland = true
config.animation_fps = 60
config.cursor_blink_rate = 500

-- Function to check if the pane is running Neovim
local function is_vim(pane)
  return pane:get_user_vars().IS_NVIM == "true"
end

-- Direction keys mapping
local direction_keys = {
  Left = "h",
  Down = "j",
  Up = "k",
  Right = "l",
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

-- Function to handle split navigation
local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "META" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- Pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
        }, pane)
      else
        -- Adjust pane size or activate pane direction based on the action
        local action = resize_or_move == "resize" and { AdjustPaneSize = { direction_keys[key], 3 } } or
        { ActivatePaneDirection = direction_keys[key] }
        win:perform_action(action, pane)
      end
    end),
  }
end

-- Key bindings
config.keys = {
  -- Split the window horizontally at the bottom with a line of 10
  {
    key = "H",
    mods = "CTRL",
    action = wezterm.action.SplitPane({
      direction = "Down",
      size = { Percent = 25 },
    }),
  },
  -- Split the window vertically to the right with a line of 50
  {
    key = "V",
    mods = "CTRL",
    action = wezterm.action.SplitPane({
      direction = "Right",
      size = { Percent = 50 },
    }),
  },
  -- Toggle the horizontal split
  { key = "-",  mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
  -- Show the selector, using the quick_select_alphabet
  { key = "o",  mods = "CTRL", action = wezterm.action({ PaneSelect = {} }) },
  -- Show the selector, using your own alphabet
  { key = "p",  mods = "CTRL", action = wezterm.action({ PaneSelect = { alphabet = "0123456789" } }) },
  -- Use cmd + t to open a new tab
  { key = "t",  mods = "CMD",  action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
  -- ctrl +b to create a horizontal split at the bottom
  { key = "b",  mods = "CTRL", action = wezterm.action.SplitPane({ direction = "Down", size = { Percent = 25 } }) },
  -- ctrl + \ to create a vertical split to the right
  { key = "\\", mods = "CTRL", action = wezterm.action.SplitPane({ direction = "Right" }) },
  -- move between split panes
  split_nav('move', 'h'),
  split_nav('move', 'j'),
  split_nav('move', 'k'),
  split_nav('move', 'l'),
  -- resize panes
  split_nav('resize', 'h'),
  split_nav('resize', 'j'),
  split_nav('resize', 'k'),
  split_nav('resize', 'l'),
}

return config
