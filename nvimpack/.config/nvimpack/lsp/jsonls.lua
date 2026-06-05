-- jsonls uses SchemaStore so JSON files pick up schema-aware validation/completion.

return {
	filetypes = { 'json' },
	settings = {
		json = {
			schemas = require('schemastore').json.schemas(),
			validate = { enable = true },
		},
	},
}
