-- Keep the debug UI dormant until it is explicitly opened.

local pack = require('sid.pack')

local load_dap_ui = pack.loader('dap-ui', {
	'https://github.com/rcarriga/nvim-dap-ui',
	'https://github.com/nvim-neotest/nvim-nio',
	'https://github.com/mfussenegger/nvim-dap',
}, function()
	require('dapui').setup()
end)

vim.keymap.set('n', '<leader>du', function()
	load_dap_ui()
	require('dapui').toggle({})
end, { desc = 'Toggle DAP UI' })

vim.keymap.set({ 'n', 'v' }, '<leader>de', function()
	load_dap_ui()
	require('dapui').eval()
end, { desc = 'Evaluate expression' })
