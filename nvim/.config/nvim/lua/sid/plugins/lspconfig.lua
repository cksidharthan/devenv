return {
	'neovim/nvim-lspconfig',
	event = 'InsertEnter',
  dependencies = {
		'folke/lazydev.nvim',
		{ 'antosha417/nvim-lsp-file-operations', config = true },
		{ 'folke/neodev.nvim', opts = {} },
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
	end,
}
