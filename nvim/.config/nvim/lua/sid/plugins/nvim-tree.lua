-- nvim-tree is command/keymap-driven rather than startup-loaded.
-- This file defines a loader plus the commands/maps that trigger it.

local pack = require('sid.pack')

local load_tree = pack.loader('nvim-tree', {
	'https://github.com/nvim-tree/nvim-tree.lua',
}, function()
	require('nvim-tree').setup({
		view = {
			width = 35,
			relativenumber = false,
			-- Keep a one-column signcolumn as a blank left margin.
			signcolumn = 'yes',
		},
		disable_netrw = true,
		hijack_netrw = true,
		hijack_cursor = true,
		hijack_unnamed_buffer_when_opening = false,
		-- Keep the tree rooted to the current project while still following the active file.
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

-- The signcolumn is our blank left margin, but on the cursor line the theme paints
-- that cell with the green CursorLineSign background. nvim-tree sets statuscolumn/
-- winhighlight when it opens its window, so schedule our overrides to run afterwards
-- (and on every open, since BufWinEnter fires each time the tree is shown):
--   - clear the statuscolumn that statuscol.nvim sets globally
--   - remap CursorLineSign to the tree's cursor-line bg so the gutter stays blank
vim.api.nvim_create_autocmd('BufWinEnter', {
	callback = function(args)
		if vim.bo[args.buf].filetype ~= 'NvimTree' then
			return
		end
		local win = vim.api.nvim_get_current_win()
		vim.schedule(function()
			if not vim.api.nvim_win_is_valid(win) then
				return
			end
			vim.wo[win].statuscolumn = ''
			vim.api.nvim_set_option_value(
				'winhighlight',
				vim.wo[win].winhighlight .. ',CursorLineSign:NvimTreeCursorLine',
				{ win = win }
			)
		end)
	end,
})

-- These placeholder commands lazy-load the plugin on first use.
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
