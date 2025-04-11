return {
	'zeioth/garbage-day.nvim',
	dependencies = 'neovim/nvim-lspconfig',
	lazy = true,
	opts = {
		-- your options here
	},
	keys = {
		{
			'<leader>garx',
			function()
				require('garbage-day.utils').stop_lsp()
			end,
      desc = 'Stop LSP Servers with Garbage Day',
		},
		{
			'<leader>gars',
			function()
				require('garbage-day.utils').start_lsp()
			end,
			desc = 'Start LSP Servers with Garbage Day',
		},
	},
}
