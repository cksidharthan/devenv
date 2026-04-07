local pack = require('sid.pack')

return pack.later('which-key', {
	'https://github.com/folke/which-key.nvim',
}, function()
	require('which-key').setup()
end)
