return {
	lazy = true,
	'olimorris/codecompanion.nvim',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-treesitter/nvim-treesitter',
		'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
		'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
		{ 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } }, -- Optional: For prettier markdown rendering
		{ 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves `vim.ui.select`
	},
	config = function()
		require('codecompanion').setup({
			adapters = {
				anthropic = function()
					return require('codecompanion.adapters').extend('anthropic', {
						env = {
							api_key = os.getenv("ANTHROPIC_API_KEY"),
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = 'copilot',
				},
				inline = {
					adapter = 'copilot',
				},
			},
		})
	end,
	cmd = {
		'CodeCompanion',
		'CodeCompanionChat',
		'CodeCompanionActions',
	},
}
