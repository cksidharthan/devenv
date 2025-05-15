return {
	'scottmckendry/cyberdream.nvim',
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd('colorscheme cyberdream')
		-- Add custom WinSeparator highlighting
		vim.api.nvim_command('highlight WinSeparator guifg=#565f89')
		-- line number coloring
		vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#51B3EC', bold = true })
		vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white', bold = true })
		vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#FB508F', bold = true })
	end,
}
