-- Markdown rendering should only load for markdown buffers.

local pack = require('sid.pack')

pack.on_event('FileType', 'render-markdown', {
	'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}, function()
	require('render-markdown').setup({
		completions = {
			blink = {
				enabled = true,
			},
		},
	})
end, {
	pattern = 'markdown',
})
