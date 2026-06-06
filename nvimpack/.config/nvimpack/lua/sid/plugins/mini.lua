local pack = require('sid.pack')

local function mini_pick_window_config()
	local lines = vim.o.lines - vim.o.cmdheight
	local columns = vim.o.columns
	local height = math.floor(0.5 * lines)
	local width = math.floor(0.5 * columns)

	return {
		relative = 'editor',
		anchor = 'NW',
		height = height,
		width = width,
		row = math.floor((lines - height) / 2),
		col = math.floor((columns - width) / 2),
	}
end

-- mini.nvim covers icons, surround, and pairs in one place.
pack.startup({
	'https://github.com/nvim-mini/mini.nvim',
})

-- Provide icon helpers early because several other plugins look for web-devicons.
require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()
require('mini.pick').setup({
	window = {
		config = mini_pick_window_config,
	},
})

-- surround is useful everywhere, but not important enough to block startup.
vim.schedule(function()
	require('mini.surround').setup()
end)
