local M = {}

function M.setup(capabilities, on_attach)
	-- Docker
	require('lspconfig').dockerls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { 'dockerfile' },
	})

	-- Docker Compose
	require('lspconfig').docker_compose_language_service.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { 'yaml.docker-compose' },
		settings = {
			docker = {
				dockerComposeFile = {
					diagnostics = {
						enable = true,
						onStartup = true,
					},
					hover = {
						enable = true,
					},
					completion = {
						enable = true,
					},
				},
			},
		},
	})

	-- YAML
	require('lspconfig').yamlls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { 'yaml', 'yaml.docker-compose' },
		settings = {
			yaml = {
				schemas = {
					kubernetes = 'k8s-*.yaml',
					['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
					['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
					['http://json.schemastore.org/chart'] = 'Chart.{yml,yaml}',
					['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = 'azure/*/*.{yml,yaml}',
					['https://taskfile.dev/schema.json'] = 'Taskfile.{yml,yaml}',
				},
				schemaStore = {
					enable = true,
				},
				validate = true,
			},
		},
	})

  -- Helm
	require('lspconfig').helm_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { 'helm' },
		settings = {
			yaml = {
				schemas = {
					kubernetes = '*.{yaml,yml}',
					['http://json.schemastore.org/chart'] = 'Chart.{yml,yaml}',
					['https://json.schemastore.org/chart.json'] = '/deployment/helm/*',
				},
			},
		},
	})

end

return M
