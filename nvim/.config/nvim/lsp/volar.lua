return {
	cmd = { 'volar' },
	filetypes = { 'vue' },
	init_options = {
		typescript = {
			tsdk = vim.fn.expand('~/') .. '.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib',
		},
		preferences = {
			disableSuggestions = true,
		},
		languageFeatures = {
			implementation = true,
			references = true,
			definition = true,
			typeDefinition = true,
			callHierarchy = true,
			hover = true,
			rename = true,
			renameFileRefactoring = true,
			signatureHelp = true,
			codeAction = true,
			workspaceSymbol = true,
			diagnostics = true,
			semanticTokens = true,
			completion = {
				defaultTagNameCase = 'both',
				defaultAttrNameCase = 'kebabCase',
				getDocumentNameCasesRequest = false,
				getDocumentSelectionRequest = false,
			},
		},
	},
}
