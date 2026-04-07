-- flash is handy, but not startup-critical, so schedule it after startup.

local pack = require('sid.pack')

local load_flash = pack.later('flash', {
	'https://github.com/folke/flash.nvim',
}, function()
	require('flash').setup({
		modes = {
			search = {
				enabled = true,
			},
		},
	})
end)
