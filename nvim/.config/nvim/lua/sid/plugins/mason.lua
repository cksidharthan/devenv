-- Mason installs external LSPs, linters, and formatters.
-- Loaded on demand the first time any Mason* command is invoked.

local pack = require('sid.pack')

local load_mason = pack.loader('mason', {
	'https://github.com/williamboman/mason.nvim',
	'https://github.com/williamboman/mason-lspconfig.nvim',
	'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
}, function()
	require('mason').setup({
		ui = {
			icons = {
				package_installed = '✓',
				package_pending = '➜',
				package_uninstalled = '✗',
			},
		},
	})

	require('mason-lspconfig').setup({
		ensure_installed = {
			'ts_ls',
			'html',
			'cssls',
			'tailwindcss',
			'lua_ls',
			'gopls',
			'pyright',
			'yamlls',
			'dockerls',
			'docker_compose_language_service',
			'helm_ls',
			'golangci_lint_ls',
			'vue_ls',
			'sqls',
			'rust_analyzer',
			'jsonls',
			'regal',
		},
		automatic_installation = true,
		automatic_enable = false,
	})

	require('mason-tool-installer').setup({
		ensure_installed = {
			'prettier',
			'stylua',
			'eslint_d',
			'golangci-lint',
			'gofumpt',
			'goimports',
			'black',
			'pylint',
			'yamllint',
			'shellcheck',
			'shfmt',
			'opa',
		},
	})
end)

-- Only :Mason needs a stub: once the plugin loads, it registers the rest
-- (MasonInstall, MasonUpdate, MasonToolsInstall, ...) itself.
pack.command('Mason', load_mason, { desc = 'Open Mason' })
