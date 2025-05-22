return {
	cmd = { 'vue-language-server', '--stdio' },
	filetypes = { 'vue' },
	init_options = {
		typescript = {
			tsdk = vim.fn.expand('~/') .. '.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib',
		},
		preferences = {
			disableSuggestions = false,
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
		vue = {
			hybridMode = false,
		},
	},
	settings = {
		typescript = {
			inlayHints = {
				enumMemberValues = {
					enabled = true,
				},
				functionLikeReturnTypes = {
					enabled = true,
				},
				propertyDeclarationTypes = {
					enabled = true,
				},
				parameterTypes = {
					enabled = true,
					suppressWhenArgumentMatchesName = true,
				},
				variableTypes = {
					enabled = true,
				},
			},
		},
	},
}
