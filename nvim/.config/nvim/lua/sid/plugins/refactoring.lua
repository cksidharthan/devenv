return {
	'ThePrimeagen/refactoring.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-treesitter/nvim-treesitter',
	},
  event = 'VeryLazy',
	config = function()
		require('refactoring').setup()
	end,
}
