local pack = require('sid.pack')

return pack.on_event({ 'BufReadPre', 'BufNewFile' }, 'flash', {
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
