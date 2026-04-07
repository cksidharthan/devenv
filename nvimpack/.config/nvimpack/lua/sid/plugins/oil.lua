local pack = require('sid.pack')

local load_oil = pack.loader('oil', {
	'https://github.com/stevearc/oil.nvim',
}, function()
	require('oil').setup({
		default_file_explorer = false,
		view_options = {
			show_hidden = true,
		},
		keymaps = {
			['q'] = 'actions.close',
		},
	})
end)

pack.command('Oil', load_oil, { nargs = '*', desc = 'Open oil.nvim' })

vim.keymap.set('n', '<leader>eo', function()
	load_oil()
	vim.cmd('Oil')
end, { desc = 'Open oil (parent directory)' })
