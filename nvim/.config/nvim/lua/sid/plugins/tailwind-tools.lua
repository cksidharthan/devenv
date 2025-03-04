-- tailwind-tools.lua
return {
	'luckasRanarison/tailwind-tools.nvim',
	name = 'tailwind-tools',
	build = ':UpdateRemotePlugins',
	ft = { 'html', 'css' },
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'nvim-telescope/telescope.nvim', -- optional
	},
	opts = {}, -- your configuration
	config = function()
		require('tailwind-tools').setup({
			-- your configuration
		})
	end,
}
