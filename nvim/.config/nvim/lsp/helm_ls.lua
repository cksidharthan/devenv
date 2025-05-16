return {
	cmd = { 'helm_ls' },
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
}
