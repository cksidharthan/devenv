return {
	filetypes = { 'go', 'gomod' },
	cmd = { 'golangci-lint-langserver' },
	init_options = {
		command = { 'golangci-lint', 'run', '--output.json.path', 'stdout', '--show-stats=false', '--issues-exit-code=1' },
	},
	root_markers = { 'go.mod', 'go.work', 'go.sum' },
}
