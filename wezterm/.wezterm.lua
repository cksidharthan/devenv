local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.font = wezterm.font_with_fallback({
	"JetbrainsMono Nerd Font",
	"MartianMono Nerd Font",
})
-- General settings
config.color_scheme = "Catppuccin Mocha"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.window_background_opacity = 1
config.macos_window_background_blur = 95
config.bold_brightens_ansi_colors = true
config.freetype_load_flags = "NO_HINTING"
config.font_size = 16
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.cell_width = 0.9
config.line_height = 1.2
-- to disable rounded corners.
-- config.window_decorations = "RESIZE|MACOS_FORCE_SQUARE_CORNERS"
config.window_decorations = "RESIZE"
config.window_padding = {
	bottom = 0,
	left = 4,
	right = 4,
	top = 10,
}
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
				local action = resize_or_move == "resize" and { AdjustPaneSize = { direction_keys[key], 3 } }
					or { ActivatePaneDirection = direction_keys[key] }
				win:perform_action(action, pane)
			end
		end),
	}
end

-- Key bindings
config.keys = {
	-- remove ctrl+p keymap to use in posting
	{
		key = "P",
		mods = "CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
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
	{ key = "-", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	-- Show the selector, using the quick_select_alphabet
	{ key = "o", mods = "CTRL", action = wezterm.action({ PaneSelect = {} }) },
	-- Show the selector, using your own alphabet
	{ key = "p", mods = "CTRL", action = wezterm.action({ PaneSelect = { alphabet = "0123456789" } }) },
	-- Use cmd + t to open a new tab
	{ key = "t", mods = "CMD", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	-- ctrl +b to create a horizontal split at the bottom
	{ key = "b", mods = "CTRL", action = wezterm.action.SplitPane({ direction = "Down", size = { Percent = 25 } }) },
	-- ctrl + \ to create a vertical split to the right
	{ key = "\\", mods = "CTRL", action = wezterm.action.SplitPane({ direction = "Right" }) },
	{ key = "1", mods = "ALT", action = wezterm.action.ShowTabNavigator },
	-- move between split panes
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
}

-- Pipe divider symbols - For the Tab Bar
local LEFT_DIVIDER = ""
local RIGHT_DIVIDER = " "

-- Function to get the current directory name to populate in the tab title
local function get_current_directory(tab)
	local current_dir = tab.active_pane.current_working_dir
	if current_dir then
		-- Convert URI format to regular path
		local path = current_dir.file_path or ""
		-- Get just the last directory name
		local dir_name = string.match(path, "[/\\]([^/\\]+)$")
		-- If we're at root, show '/'
		return dir_name or path:match("[/\\]$") and "/" or path
	end
	return "wezterm"
end

-- Main tab title formatting
wezterm.on("format-tab-title", function(tab, hover)
	local edge_background = "#0b0022"
	local background = "#05fef3" -- Orange background
	local foreground = "#000000" -- Black text for better contrast on orange
	local divider_color = "#ffffff" -- White color for dividers

	if tab.is_active then
		background = "#ffad33" -- Lighter orange for active tab
		foreground = "#000000"
	elseif hover then
		background = "#ffffff"
		foreground = "#000000"
	end

	local title = get_current_directory(tab)
	local tab_number = tab.tab_index + 1 -- Adding 1 because tab_index is 0-based

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = divider_color } },
		{ Text = LEFT_DIVIDER },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = " " .. tab_number .. ": " .. title .. " " }, -- Added tab number here
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = divider_color } },
		{ Text = RIGHT_DIVIDER },
	}
end)

config.tab_max_width = 45

return config
