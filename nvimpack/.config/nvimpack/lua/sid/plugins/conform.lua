-- Formatting is loaded on demand the first time a format map is used.
-- This keeps formatter setup out of startup while still making the keymaps always available.

local pack = require('sid.pack')

local load_conform = pack.loader('conform', {
	'https://github.com/stevearc/conform.nvim',
}, function()
	require('conform').setup({
		formatters_by_ft = {
			bash = { 'shfmt' },
			css = { 'prettier' },
			go = { 'goimports', 'gofmt' },
			html = { 'prettier' },
			javascript = { 'prettier' },
			javascriptreact = { 'prettier' },
			json = { 'prettier' },
			jsonc = { 'prettier' },
			lua = { 'stylua' },
			markdown = { 'prettier' },
			proto = { 'buf' },
			python = { 'black' },
			scss = { 'prettier' },
			sh = { 'shfmt' },
			toml = { 'taplo' },
			typescript = { 'prettier' },
			typescriptreact = { 'prettier' },
			yaml = { 'prettier' },
		},
	})
end)

local function format()
	load_conform()
	-- Synchronous formatting keeps the command predictable when chained with save/other actions.
	require('conform').format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	})
end

vim.keymap.set({ 'n', 'v' }, '<leader>cf', format, { desc = 'Format file or selection' })
vim.keymap.set({ 'n', 'v' }, '<leader>mp', format, { desc = 'Format file or selection' })

return {
	load = load_conform,
}
