return {
	'olimorris/codecompanion.nvim',
	opts = {},
	event = 'BufReadPre',
	cmd = {
		'CodeCompanion',
		'CodeCompanionChat',
		'CodeCompanionCmd',
		'CodeCompanionActions',
	},
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-treesitter/nvim-treesitter',
	},
	config = function()
		require('codecompanion').setup({
			opts = {
				-- send_code = false,
			},
			strategies = {
				chat = {
					adapter = 'copilot',
				},
				inline = {
					adapter = 'copilot',
				},
				cmd = {
					adapter = 'copilot',
				},
			},
			adapters = {
				http = {
					openai = function()
						return require('codecompanion.adapters').extend('openai', {
							env = {
								api_key = 'cmd:echo $OPENAI_API_KEY',
							},
						})
					end,
					anthropic = function()
						return require('codecompanion.adapters').extend('anthropic', {
							env = {
								api_key = 'cmd:echo $ANTHROPIC_API_KEY',
							},
						})
					end,
				},
			},
		})
	end,
}
