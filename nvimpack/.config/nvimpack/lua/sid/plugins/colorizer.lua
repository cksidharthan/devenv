-- Color previews are cosmetic, so wait for the first real buffer.

local pack = require('sid.pack')

pack.on_event({ 'BufReadPre', 'BufNewFile' }, 'colorizer', {
	'https://github.com/NvChad/nvim-colorizer.lua',
}, function()
	require('colorizer').setup({
		user_default_options = {
			names = false,
			tailwind = true,
		},
	})
end)
