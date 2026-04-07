local pack = require('sid.pack')

return pack.on_event({ 'BufReadPre', 'BufNewFile' }, 'conform', {
	'https://github.com/stevearc/conform.nvim',
}, function()
	local conform = require('conform')

	conform.setup({
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

	local format = function()
		conform.format({
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		})
	end

	vim.keymap.set({ 'n', 'v' }, '<leader>cf', format, { desc = 'Format file or selection' })
	vim.keymap.set({ 'n', 'v' }, '<leader>mp', format, { desc = 'Format file or selection' })
end)
