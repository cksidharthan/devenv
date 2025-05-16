return {
	filetypes = { 'go', 'gomod' },
	cmd = { 'golangci-lint-langserver' },
	root_dir = require('lspconfig').util.root_pattern('.git', 'go.mod'),
}
