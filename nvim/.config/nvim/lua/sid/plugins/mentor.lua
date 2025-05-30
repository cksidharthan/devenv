return {
	'cksidharthan/mentor.nvim',
	-- dir = '/Users/yd83ap/dev/cksidharthan/mentor.nvim',
	-- dev = true,
	config = function()
		-- In your init.lua or other Neovim config file
		require('mentor').setup({
			-- Your custom tips
			tips = {
        "Are you sure you want to work now? :) "
			},
			-- Set to false to only use your custom tips
			use_default = true
		})
	end,
	event = 'VimEnter',
}
