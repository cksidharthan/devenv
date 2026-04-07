local pack = require('sid.pack')

local load_tree = pack.loader('nvim-tree', {
	'https://github.com/nvim-tree/nvim-tree.lua',
}, function()
	require('nvim-tree').setup({
		view = {
			width = 35,
			relativenumber = false,
		},
		disable_netrw = true,
		hijack_netrw = true,
		hijack_cursor = true,
		hijack_unnamed_buffer_when_opening = false,
		sync_root_with_cwd = true,
		update_focused_file = {
			enable = true,
			update_root = false,
		},
		renderer = {
			root_folder_modifier = ':t',
			indent_markers = {
				enable = true,
			},
			icons = {
				glyphs = {
					default = '󰈚 ',
					symlink = ' ',
					folder = {
						default = ' ',
						empty = ' ',
						empty_open = ' ',
						open = ' ',
						symlink = ' ',
						symlink_open = ' ',
						arrow_open = '▼',
						arrow_closed = '▶',
					},
					git = {
						unstaged = '✗',
						staged = '✓',
						unmerged = ' ',
						renamed = '➜',
						untracked = '★',
						deleted = ' ',
						ignored = '◌',
					},
				},
			},
		},
		actions = {
			open_file = {
				window_picker = {
					enable = true,
				},
				resize_window = true,
			},
		},
		filters = {
			custom = { '.DS_Store', '.trunk', '.vscode', 'node_modules' },
		},
		git = {
			ignore = false,
		},
	})
end)

pack.command('NvimTreeToggle', load_tree, { nargs = 0, desc = 'Toggle NvimTree' })
pack.command('NvimTreeRefresh', load_tree, { nargs = 0, desc = 'Refresh NvimTree' })

vim.keymap.set('n', '<leader>ee', function()
	load_tree()
	vim.cmd('NvimTreeToggle')
end, { desc = 'Toggle file tree' })

vim.keymap.set('n', '<leader>en', function()
	load_tree()
	vim.cmd('NvimTreeRefresh')
end, { desc = 'Refresh file tree' })

return {
	load = load_tree,
}
