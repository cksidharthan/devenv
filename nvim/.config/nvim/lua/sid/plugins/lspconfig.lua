return {
	'neovim/nvim-lspconfig',
	event = 'InsertEnter',
	dependencies = {
		'folke/lazydev.nvim',
		'jose-elias-alvarez/typescript.nvim',
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		'b0o/schemastore.nvim', -- Add schemastore for JSON schemas
	},
	config = function()
		vim.lsp.enable('gopls')
		vim.lsp.enable('golangci_lint_ls')
		vim.lsp.enable('dockerls')
		vim.lsp.enable('docker_compose_language_service')
		vim.lsp.enable('helm_ls')
		vim.lsp.enable('html')
		vim.lsp.enable('jsonls')
		vim.lsp.enable('lua_ls')
		vim.lsp.enable('pyright')
		vim.lsp.enable('rust_analyzer')
		vim.lsp.enable('sqls')
		vim.lsp.enable('tailwindcss')
		vim.lsp.enable('ts_ls')
		vim.lsp.enable('volar')
		vim.lsp.enable('yamlls')

    -- show icons in lsp diagnostics
		vim.diagnostic.config({
			signs = {
				numhl = {
					[vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
					[vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
					[vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
					[vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
				},
				text = {
					[vim.diagnostic.severity.ERROR] = '󰅚 ',
					[vim.diagnostic.severity.WARN] = '󰀪 ',
					[vim.diagnostic.severity.INFO] = ' ',
					[vim.diagnostic.severity.HINT] = '󰌶 ',
				},
			},
			update_in_insert = true,
			virtual_text = false,
			virtual_lines = { current_line = true },
		})
	end,
}
