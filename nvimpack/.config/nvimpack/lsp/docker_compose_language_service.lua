-- Per-server override for docker compose YAML files.
-- Neovim picks this up when vim.lsp.enable('docker_compose_language_service') runs.

return {
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
}
