-- yamlls override: pulls schemas from SchemaStore.nvim and overlays project-specific mappings.

return {
	filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.azure-pipelines' },
	settings = {
		yaml = {
			-- SchemaStore.nvim ships its own catalog, so disable the built-in store
			-- to avoid duplicate/conflicting schemas being registered.
			schemaStore = {
				enable = false,
				url = '',
			},
			schemas = vim.tbl_deep_extend(
				'force',
				require('schemastore').yaml.schemas(),
				{
					kubernetes = 'k8s-*.yaml',
					['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
					['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
					['http://json.schemastore.org/chart'] = 'Chart.{yml,yaml}',
					['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = {
						'azure/**/**.{yml,yaml}',
						'pipeline/**/**.{yml,yaml}',
						'pipelines/**/.**.{yml,yaml}',
					},
					['https://taskfile.dev/schema.json'] = 'Taskfile.{yml,yaml}',
				}
			),
			validate = false,
		},
	},
}
