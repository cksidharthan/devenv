-- vue_ls (Vue language server v3+) runs in "hybrid mode" only: it handles the
-- template/style sections of *.vue files and forwards every TypeScript request
-- to ts_ls, which loads @vue/typescript-plugin (see lsp/ts_ls.lua).
--
-- Takeover mode and the old init_options schema (languageFeatures, vue.hybridMode,
-- tsdk, ...) were removed in v3.0.0, so this override is intentionally minimal.
-- nvim-lspconfig's bundled vue_ls config provides cmd/root_markers and the on_init
-- handler that bridges `tsserver/request` -> ts_ls -> `tsserver/response`.
return {
	filetypes = { 'vue' },
}
