-- Use golangci-lint as an LSP-style diagnostics source for Go projects.

return {
	filetypes = { 'go', 'gomod' },
	init_options = {
		command = {
			'golangci-lint',
			'run',
			'--output.json.path',
			'stdout',
			'--show-stats=false',
			'--issues-exit-code=1',
		},
	},
	root_markers = { 'go.mod', 'go.work', 'go.sum' },
}
