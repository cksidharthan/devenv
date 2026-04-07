local pack = require('sid.pack')

return pack.later('flash', {
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
