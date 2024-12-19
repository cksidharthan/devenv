return {
	'ray-x/go.nvim',
	dependencies = { -- optional packages
		'ray-x/guihua.lua',
		'neovim/nvim-lspconfig',
		'nvim-treesitter/nvim-treesitter',
	},
	config = function()
		require('go').setup({
			lsp_inlay_hints = {
				enable = false,
        style = 'inlay',
        only_current_line = true,
        show_parameter_hints = false,
			},
		})
	end,
	lazy = true,
	ft = { 'go', 'gomod' },
}
