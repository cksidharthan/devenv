return {
	'saghen/blink.cmp',
	version = '*',
	event = { 'InsertEnter' },
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			preset = 'none',
			['<C-j>'] = { 'select_next', 'fallback' },
			['<C-k>'] = { 'select_prev', 'fallback' },
      -- accept down arrow and up arrow
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<Up>'] = { 'select_prev', 'fallback' },
			-- press enter to confirm completion
			['<CR>'] = { 'select_and_accept', 'fallback' },
      -- press ctrl + space to trigger completion
      ['<C-Space>'] = { 'show', 'fallback' },
		},

		appearance = {
			nerd_font_variant = 'mono',
		},

		signature = {
			enabled = false,
			window = {
				border = 'single',
			},
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				window = {
					border = 'single',
				},
			},
			menu = {
				border = 'single',
				draw = {
					treesitter = { 'lsp' },
					columns = { { 'kind_icon', 'label', 'label_description', gap = 1 }, { 'kind' } },
				},
			},
		},

		sources = {
			default = { 'lsp', 'path' },
		},

		fuzzy = { implementation = 'prefer_rust_with_warning' },
	},
	opts_extend = { 'sources.default' },
}
