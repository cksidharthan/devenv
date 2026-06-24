-- lazydev.nvim manages workspace.library on demand, so we intentionally do not
-- preload the entire Neovim runtime here. That avoids re-indexing each time a
-- new lua buffer is opened.

return {
	root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				checkThirdParty = false,
			},
		},
	},
}
