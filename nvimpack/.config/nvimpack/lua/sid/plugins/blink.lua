local pack = require('sid.pack')

return pack.on_event('InsertEnter', 'blink', {
	'https://github.com/saghen/blink.cmp',
}, function()
	require('blink.cmp').setup({
		appearance = {
			nerd_font_variant = 'mono',
		},
		keymap = {
			preset = 'none',
			['<C-j>'] = { 'select_next', 'fallback' },
			['<C-k>'] = { 'select_prev', 'fallback' },
			['<Down>'] = { 'select_next', 'fallback' },
			['<Up>'] = { 'select_prev', 'fallback' },
			['<CR>'] = { 'select_and_accept', 'fallback' },
			['<C-Space>'] = { 'show', 'fallback' },
		},
		enabled = function()
			return not vim.tbl_contains({
				'NvimTree',
				'TelescopePrompt',
				'noice',
			}, vim.bo.filetype) and vim.bo.buftype ~= 'prompt'
		end,
		signature = {
			enabled = false,
			window = {
				border = 'single',
				show_documentation = false,
			},
		},
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 300,
				window = {
					border = 'single',
				},
			},
			accept = { auto_brackets = { enabled = true } },
			menu = {
				border = 'single',
				draw = {
					treesitter = { 'lsp' },
					columns = {
						{ 'kind_icon', 'label', 'label_description', gap = 1 },
						{ 'kind' },
					},
				},
			},
		},
		cmdline = {
			enabled = true,
			completion = {
				ghost_text = {
					enabled = false,
				},
			},
		},
		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
		},
		fuzzy = {
			implementation = 'prefer_rust_with_warning',
		},
	})
end)
