-- gitsigns adds gutter markers once a real file is opened.

local pack = require('sid.pack')

local load_gitsigns = pack.on_event({ 'BufReadPre', 'BufNewFile' }, 'gitsigns', {
	'https://github.com/lewis6991/gitsigns.nvim',
}, function()
	require('gitsigns').setup({
		signs = {
			add = { text = '┃' },
			change = { text = '┃' },
			delete = { text = '_' },
			topdelete = { text = '‾' },
			changedelete = { text = '~' },
			untracked = { text = '┆' },
		},
		signcolumn = true,
		numhl = false,
		linehl = false,
		current_line_blame = false,
		watch_gitdir = {
			follow_files = true,
		},
	})
end)
