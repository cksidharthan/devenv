return {
	'yetone/avante.nvim',
	version = false, -- set this if you want to always pull the latest change
	lazy = true,
	build = 'make',
	cmd = {
		'AvanteAsk',
		'AvanteChat',
		'AvanteSwitchProvider',
		'AvanteToggle',
	},
	config = function()
		require('avante').setup({
			auto_suggestions_provider = 'copilot',
			provider = 'claude', -- Recommend using Claude
			claude = {
				endpoint = 'https://api.anthropic.com',
				model = 'claude-3-5-sonnet-20241022',
				temperature = 0,
				max_tokens = 4096,
			},
			ask = {
				floating = true, -- Open the 'AvanteAsk' prompt in a floating window
				start_insert = true, -- Start insert mode when opening the ask window, only effective if floating = true.
				border = 'rounded',
			},
		})
	end,
	dependencies = {
		'stevearc/dressing.nvim',
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
		--- The below dependencies are optional,
		'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
		'zbirenbaum/copilot.lua', -- for providers='copilot'
		{
			-- Make sure to set this up properly if you have lazy=true
			'MeanderingProgrammer/render-markdown.nvim',
			opts = {
				file_types = { 'markdown', 'Avante' },
			},
			ft = { 'markdown', 'Avante' },
		},
	},
}
