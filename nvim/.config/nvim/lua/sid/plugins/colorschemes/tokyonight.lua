return {
	'folke/tokyonight.nvim',
	event = 'VeryLazy',
	priority = 1000,
	config = function()
		vim.cmd('colorscheme tokyonight-night')
		-- Add custom WinSeparator highlighting
		vim.api.nvim_command('highlight WinSeparator guifg=#565f89')
	end,
	opts = {},
}
