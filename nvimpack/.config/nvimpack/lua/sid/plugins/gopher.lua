-- go.nvim is only needed for Go buffers, so keep it off the startup path.

local pack = require('sid.pack')

local load_gopher = pack.on_event('FileType', 'gopher', {
	'https://github.com/ray-x/go.nvim',
	'https://github.com/ray-x/guihua.lua',
}, function()
	require('go').setup({
		lsp_inlay_hints = {
			enable = false,
			style = 'inlay',
			only_current_line = true,
			show_parameter_hints = false,
		},
	})
end, {
	pattern = { 'go', 'gomod' },
})
