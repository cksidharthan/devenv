return {
	cmd = { 'vscode-json-language-server' },
	filetypes = { 'jsonv' },
	settings = {
		json = {
			-- Use schemastore catalog for JSON schema completion
			schemas = require('schemastore').json.schemas(),
			validate = { enable = true },
		},
	},
}
