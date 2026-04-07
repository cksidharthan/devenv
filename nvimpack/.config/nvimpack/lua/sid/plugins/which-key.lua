-- which-key is pure UI sugar, so it can load after startup settles.

local pack = require('sid.pack')

local load_which_key = pack.later('which-key', {
	'https://github.com/folke/which-key.nvim',
}, function()
	require('which-key').setup()
end)
