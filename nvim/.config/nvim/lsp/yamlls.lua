return {
	cmd = { 'yamlls' },
	filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.azure-pipelines' },
	settings = {
		yaml = {
			schemas = {
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
			},
			schemaStore = {
				enable = true,
			},
			validate = true,
		},
	},
}
