return {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' }, -- Recognize 'vim' as a global
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file('', true), -- Include Neovim runtime files
				checkThirdParty = false,
			},
		},
	},
}
