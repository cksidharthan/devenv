return {
  cmd = { "docker-compose-langserver" },
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
