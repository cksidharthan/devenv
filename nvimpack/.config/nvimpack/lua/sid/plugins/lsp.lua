local pack = require('sid.pack')

local function configure_lsp()
	require('lazydev').setup({
		library = {
			{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
		},
	})

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

	if vim.uv.fs_stat('/Users/sid/dev/cksidharthan/educationlsp/main') then
		vim.lsp.enable('educationlsp')
	end
end

return pack.on_event({ 'BufReadPre', 'BufNewFile' }, 'lsp', {
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/folke/lazydev.nvim',
	'https://github.com/b0o/SchemaStore.nvim',
}, configure_lsp)
