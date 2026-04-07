-- blink.compat bridges nvim-cmp sources into blink.cmp.
-- Keep it on the 2.x line for blink.cmp v1.x.
local pack = require('sid.pack')

local load_blink_compat = pack.on_event('InsertEnter', 'blink-compat', {
	{
		src = 'https://github.com/saghen/blink.compat',
		version = vim.version.range('2'),
	},
}, function()
	require('blink.compat').setup()
end)
