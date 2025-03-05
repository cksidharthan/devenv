return {
	'stevearc/oil.nvim',
	opts = {},
	cmd = {
		'Oil',
	},
	-- Optional dependencies
	dependencies = { 'echasnovski/mini.icons' },
	keys = {
		{ '<leader>o', '<cmd>Oil<CR>', desc = 'Open Oil' },
	},
}
