local pack = require('sid.pack')

local load_noice = pack.later('noice', {
	'https://github.com/MunifTanjim/nui.nvim',
	'https://github.com/rcarriga/nvim-notify',
	'https://github.com/folke/noice.nvim',
}, function()
	require('notify').setup({
		render = 'compact',
		stages = 'slide',
		fps = 120,
	})

	require('noice').setup({
		lsp = {
			override = {
				['vim.lsp.util.convert_input_to_markdown_lines'] = true,
				['vim.lsp.util.stylize_markdown'] = true,
			},
			signature = {
				enabled = true,
				auto_show = false,
			},
			message = {
				enabled = false,
			},
		},
		cmdline = {
			format = {
				cmdline = { icon = '❯' },
			},
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			lsp_doc_border = true,
		},
		routes = {
			{
				filter = { event = 'notify', find = 'No signature help available' },
				opts = { skip = true },
			},
			{
				filter = { event = 'lsp', find = 'signature help not available' },
				opts = { skip = true },
			},
			{
				filter = { event = 'lsp', kind = 'signature', find = 'signature_help' },
				opts = { skip = true },
			},
		},
	})

	pcall(function()
		require('telescope').load_extension('noice')
	end)
end)

vim.keymap.set('n', '<leader>nd', function()
	load_noice()
	vim.cmd('NoiceDismiss')
end, { desc = 'Dismiss notifications' })

return {
	load = load_noice,
}
