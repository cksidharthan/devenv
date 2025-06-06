return {
	'cksidharthan/togglewiz.nvim',
	-- dir = vim.fn.expand('~/dev/cksidharthan/togglewiz.nvim'),
	-- dev = true,
	config = function()
		require('togglewiz').setup({
			toggles = {
				{ name = 'SuperMaven', enable_cmd = 'SupermavenStart', disable_cmd = 'SupermavenStop', state = false },
				{ name = 'LSP', enable_cmd = 'LspStart', disable_cmd = 'LspStop', state = false },
				{ name = 'Mentor', enable_cmd = 'Mentor', disable_cmd = 'Mentor', state = true },
				{ name = 'Diagnostics', enable_cmd = 'lua vim.diagnostic.enable()', disable_cmd = 'lua vim.diagnostic.disable()', state = true, },
				{ name = 'Formatting', enable_cmd = 'lua vim.g.format_on_save = true', disable_cmd = 'lua vim.g.format_on_save = false', state = false, },
			},
			icons = {
				enabled = '✅', -- Custom icon for enabled features
				disabled = '❌', -- Custom icon for disabled features
			},
      close_on_toggle = true,
		})
	end,
  keys = {
		{ '<leader>tw', '<cmd>ToggleWiz<cr>', desc = 'Open togglewiz', },
  }
}
