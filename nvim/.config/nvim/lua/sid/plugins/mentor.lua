return {
	'cksidharthan/mentor.nvim',
	--  dir = vim.fn.expand('~/dev/cksidharthan/mentor.nvim'),
	-- dev = true,
	config = function()
		-- In your init.lua or other Neovim config file
		require('mentor').setup({
			tips = {
				'Are you sure you want to work now? :) ',
			},
			defaults = {
				enabled = true,
			},
		})
	end,
	event = 'VimEnter',
}
