return {
  cmd = { "docker_compose_language_server" },
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
