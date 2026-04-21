-- Debugging is entirely keymap-driven here, so keep it off the startup path.

local pack = require('sid.pack')

local load_dap = pack.loader('dap', {
	'https://github.com/mfussenegger/nvim-dap',
	'https://github.com/leoluz/nvim-dap-go',
}, function()
	require('dap-go').setup()
end)

local function with_dap(callback)
	return function()
		load_dap()
		callback(require('dap'))
	end
end

vim.keymap.set('n', '<leader>dB', function()
	load_dap()
	require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Breakpoint condition' })

vim.keymap.set('n', '<leader>db', with_dap(function(dap)
	dap.toggle_breakpoint()
end), { desc = 'Toggle breakpoint' })

vim.keymap.set('n', '<leader>dc', with_dap(function(dap)
	dap.continue()
end), { desc = 'Run or continue' })

vim.keymap.set('n', '<leader>dC', with_dap(function(dap)
	dap.run_to_cursor()
end), { desc = 'Run to cursor' })

vim.keymap.set('n', '<leader>dg', with_dap(function(dap)
	dap.goto_()
end), { desc = 'Goto line without executing' })

vim.keymap.set('n', '<leader>di', with_dap(function(dap)
	dap.step_into()
end), { desc = 'Step into' })

vim.keymap.set('n', '<leader>dj', with_dap(function(dap)
	dap.down()
end), { desc = 'Down stack frame' })

vim.keymap.set('n', '<leader>dk', with_dap(function(dap)
	dap.up()
end), { desc = 'Up stack frame' })

vim.keymap.set('n', '<leader>dl', with_dap(function(dap)
	dap.run_last()
end), { desc = 'Run last' })

vim.keymap.set('n', '<leader>do', with_dap(function(dap)
	dap.step_out()
end), { desc = 'Step out' })

vim.keymap.set('n', '<leader>dO', with_dap(function(dap)
	dap.step_over()
end), { desc = 'Step over' })

vim.keymap.set('n', '<leader>dP', with_dap(function(dap)
	dap.pause()
end), { desc = 'Pause' })

vim.keymap.set('n', '<leader>dr', with_dap(function(dap)
	dap.repl.toggle()
end), { desc = 'Toggle REPL' })

vim.keymap.set('n', '<leader>dS', with_dap(function(dap)
	dap.session()
end), { desc = 'Session' })

vim.keymap.set('n', '<leader>dt', with_dap(function(dap)
	dap.terminate()
end), { desc = 'Terminate' })

vim.keymap.set('n', '<leader>dw', with_dap(function()
	require('dap.ui.widgets').hover()
end), { desc = 'Inspect expression' })
