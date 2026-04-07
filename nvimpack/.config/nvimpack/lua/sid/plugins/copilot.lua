-- GitHub Copilot suggestions via copilot.lua.
-- Loads on the first InsertEnter so it doesn't slow down startup.

local pack = require('sid.pack')

local load = pack.on_event('InsertEnter', 'copilot', {
	'https://github.com/zbirenbaum/copilot.lua',
	'https://github.com/copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
}, function()
	require('copilot').setup({
		suggestion = {
			enabled = false,
		},
		copilot_model = 'gpt-41-copilot',
		panel = {
			enabled = false,
		},
		filetypes = {
			['.'] = true,
			md = true,
			markdown = true,
			go = true,
			yaml = true,
			json = true,
			toml = true,
			tmux = true,
			lua = true,
			python = true,
			conf = true,
			javascript = true,
			typescript = true,
		},
		server_opts_overrides = {},
	})
end)

-- Keymaps trigger the loader on first use, then run the real Copilot command.
vim.keymap.set('n', '<leader>cod', function()
	load()
	vim.cmd('Copilot disable')
end, { desc = 'Copilot disable' })

vim.keymap.set('n', '<leader>coe', function()
	load()
	vim.cmd('Copilot enable')
end, { desc = 'Copilot enable' })
