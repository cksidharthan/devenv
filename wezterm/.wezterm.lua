local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.color_scheme = "Dark+"
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.9
config.macos_window_background_blur = 90
config.bold_brightens_ansi_colors = true
config.font_size = 15
config.line_height = 1.1
config.window_decorations = "RESIZE"
-- config.font = wezterm.font 'UbuntuSansMono Nerd Font Mono'

local function is_vim(pane)
	local process_info = pane:get_foreground_process_info()
	local process_name = process_info and process_info.name

	return process_name == "nvim" or process_name == "vim"
end

local function find_vim_pane(tab)
	for _, pane in ipairs(tab:panes()) do
		if is_vim(pane) then
			return pane
		end
	end
end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	-- reverse lookup
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

config.window_padding = {
	bottom = 0,
	left = 4,
	right = 4,
	top = 0,
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end
-- split the window horizontally
config.keys = {
	-- {key="|", mods="CTRL", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
	-- split the window horizontally at the bottom with a line of 10
	{
		key = "H",
		mods = "CTRL",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = {
				Percent = 25,
			},
		}),
	},
	{
		key = "V",
		mods = "CTRL",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = {
				Percent = 50,
			},
		}),
	},
	-- toggle the horizontal split
	{ key = "-", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	-- Show the selector, using the quick_select_alphabet
	{ key = "o", mods = "CTRL", action = wezterm.action({ PaneSelect = {} }) },
	-- Show the selector, using your own alphabet
	{ key = "p", mods = "CTRL", action = wezterm.action({ PaneSelect = { alphabet = "0123456789" } }) },
	-- use cmd + t to open a new tab
	{ key = "t", mods = "CMD", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },

	{
		key = ";",
		mods = "CTRL",
		action = wezterm.action_callback(function(window, pane)
			local tab = window:active_tab()

			-- Open pane below if current pane is vim
			if is_vim(pane) then
				if (#tab:panes()) == 1 then
					-- Open pane below if when there is only one pane and it is vim
					pane:split({ direction = "Bottom" })
				else
					-- Send `CTRL-; to vim`, navigate to bottom pane from vim
					window:perform_action({
						SendKey = { key = ";", mods = "CTRL" },
					}, pane)
				end
				return
			end

			-- Zoom to vim pane if it exists
			local vim_pane = find_vim_pane(tab)
			if vim_pane then
				vim_pane:activate()
				tab:set_zoomed(true)
			end
		end),
	},
}

return config