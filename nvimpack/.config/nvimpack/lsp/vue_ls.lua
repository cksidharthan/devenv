-- vue_ls handles Vue-specific language features.
-- If mason's bundled TypeScript SDK exists, point vue_ls at it for consistent behavior.

local tsdk_path = vim.fs.joinpath(
	vim.fn.stdpath('data'),
	'mason',
	'packages',
	'vue-language-server',
	'node_modules',
	'typescript',
	'lib'
)

return {
	filetypes = { 'vue' },
	init_options = {
		-- Passing tsdk is optional; when absent, vue_ls falls back to its default resolution.
		typescript = vim.uv.fs_stat(tsdk_path) and { tsdk = tsdk_path } or nil,
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
