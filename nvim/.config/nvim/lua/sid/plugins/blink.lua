-- blink.cmp is completion for insert mode.
-- It loads on the first InsertEnter so startup stays cheap.

local pack = require('sid.pack')

vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(event)
		local data = event.data
		if data.spec.name ~= 'blink.cmp' then
			return
		end
		if data.kind ~= 'install' and data.kind ~= 'update' then
			return
		end
		-- blink.cmp v2 ships its own build/download system for the Rust fuzzy
		-- matcher (the native lib now lives in blink.lib). It downloads a prebuilt
		-- binary when available and falls back to `cargo build` otherwise, so prefer
		-- it over calling cargo directly. It needs the plugins on the runtimepath.
		for _, name in ipairs({ 'blink.lib', 'blink.cmp' }) do
			pcall(vim.cmd.packadd, name)
		end
		local ok, err = pcall(function()
			require('blink.cmp').build():pwait()
		end)
		if not ok then
			vim.notify('Failed to build blink.cmp fuzzy matcher: ' .. tostring(err), vim.log.levels.WARN)
		end
	end,
})

local load_blink = pack.on_event('InsertEnter', 'blink', {
	-- blink.cmp v2 split its shared library out into blink.lib; it must be on the
	-- runtimepath before blink.cmp loads.
	'https://github.com/saghen/blink.lib',
	'https://github.com/saghen/blink.cmp',
	'https://github.com/fang2hou/blink-copilot',
}, function()
	local default_sources = { 'copilot', 'lsp', 'path', 'snippets', 'buffer' }
	local providers = {
		copilot = { name = 'copilot', module = 'blink-copilot', score_offset = 100, async = true },
	}

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
			-- Disable completion UI in prompt-style buffers where it gets in the way.
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
			enabled = false,
		},
		sources = {
			default = default_sources,
			providers = providers,
		},

		fuzzy = {
			implementation = 'prefer_rust',
		},
	})
end)
