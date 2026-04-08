-- oil is the "edit directories like buffers" explorer.
-- It is kept alongside nvim-tree because the workflows are different.

local pack = require('sid.pack')

local load_grug_far = pack.loader('grug-far', {
	'https://github.com/MagicDuck/grug-far.nvim',
}, function()
	-- optional setup call to override plugin options
	-- alternatively you can set options with vim.g.grug_far = { ... }
	require('grug-far').setup({
		-- options, see Configuration section below
		-- there are no required options atm
		-- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
		-- be specified
		engine = 'ripgrep',
	})
end)

pack.command('GrugFar', load_grug_far(), { nargs = '*', desc = 'Open Grug Far to Search and Replace' })

vim.keymap.set('n', '<leader>sr', function()
	load_grug_far()
	vim.cmd('GrugFar')
end, { desc = 'Open grug far to search and replace' })
