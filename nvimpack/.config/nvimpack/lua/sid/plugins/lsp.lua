-- This file owns shared LSP behavior: diagnostics, common keymaps, and server enablement.
-- Per-server overrides live in ../lsp/*.lua.

local pack = require('sid.pack')

local function configure_lsp()
	-- lazydev improves Lua completion for Neovim config/plugin development.
	require('lazydev').setup({
		library = {
			{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
		},
	})

	-- Keep diagnostics informative without flooding the screen with virtual text.
	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = '󰅚 ',
				[vim.diagnostic.severity.WARN] = '󰀪 ',
				[vim.diagnostic.severity.INFO] = ' ',
				[vim.diagnostic.severity.HINT] = '󰌶 ',
			},
			numhl = {
				[vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
				[vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
				[vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
				[vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
			},
		},
		update_in_insert = false,
		virtual_text = false,
		virtual_lines = false,
	})

	-- Enable the servers that this config expects to have installed externally.
	local servers = {
		'docker_compose_language_service',
		'dockerls',
		'gopls',
		'golangci_lint_ls',
		'helm_ls',
		'html',
		'jsonls',
		'lua_ls',
		'pyright',
		'regal',
		'rust_analyzer',
		'sqls',
		'tailwindcss',
		'ts_ls',
		'vue_ls',
		'yamlls',
	}

	for _, server in ipairs(servers) do
		vim.lsp.enable(server)
	end

	-- Local custom language server used only when the binary exists on this machine.
	if vim.uv.fs_stat('/Users/sid/dev/cksidharthan/educationlsp/main') then
		vim.lsp.enable('educationlsp')
	end
end

-- These are set up eagerly because they are safe even before a server attaches.
vim.keymap.set('n', 'K', function()
	vim.lsp.buf.hover()
end, { desc = 'Hover documentation' })
vim.keymap.set('n', 'gD', function()
	vim.lsp.buf.declaration()
end, { desc = 'Goto declaration' })
vim.keymap.set({ 'n', 'x' }, '<leader>ca', function()
	vim.lsp.buf.code_action()
end, { desc = 'Code action' })
vim.keymap.set('n', '<leader>rn', function()
	vim.lsp.buf.rename()
end, { desc = 'Rename symbol' })
vim.keymap.set('n', '<leader>cd', function()
	vim.diagnostic.open_float()
end, { desc = 'Line diagnostics' })
vim.keymap.set('n', ']d', function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Previous diagnostic' })

-- :LspInfo and friends were removed from nvim-lspconfig when the native
-- vim.lsp.config API landed. These shims restore the muscle memory:
--   :LspInfo        -> clients attached to the current buffer
--   :LspInfoActive  -> all clients in the current Neovim session
--   :LspInfoAll     -> full :checkhealth vim.lsp report
vim.api.nvim_create_user_command('LspInfo', function()
	print(vim.inspect(vim.lsp.get_clients({ bufnr = 0 })))
end, { desc = 'LSP clients attached to current buffer' })

vim.api.nvim_create_user_command('LspInfoActive', function()
	print(vim.inspect(vim.lsp.get_clients()))
end, { desc = 'All active LSP clients in this session' })

vim.api.nvim_create_user_command('LspInfoAll', function()
	vim.cmd('checkhealth vim.lsp')
end, { desc = 'Full vim.lsp checkhealth report' })

local load_lsp = pack.on_event({ 'BufReadPre', 'BufNewFile' }, 'lsp', {
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/folke/lazydev.nvim',
	'https://github.com/b0o/SchemaStore.nvim',
}, configure_lsp)
