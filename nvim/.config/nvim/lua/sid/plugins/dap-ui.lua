return {
	'rcarriga/nvim-dap-ui',
	lazy = true,
	dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio', 'rcarriga/cmp-dap' },
	opts = {
		mappings = { expand = { '<CR>', '<2-LeftMouse>' }, open = 'o', remove = 'd', edit = 'e', repl = 'r' },
		force_buffers = false,
		element_mappings = { close = { 'q', '<Esc>' } },
		floating = {
			max_height = nil,
			max_width = nil,
			mappings = { close = { 'q', '<Esc>' } },
			border = { enable = true, focusable = true, highlight = 'Normal' },
		},
		render = { show_on = 'never', indent = 2 },
		border = { enable = true, focusable = true, highlight = 'Normal' },
		icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
		controls = {
			enabled = true,
			element = 'repl',
			icons = {
				pause = '',
				play = '',
				step_into = '',
				step_over = '', -- Updated icon for step over
				step_out = '',
				step_back = '',
				run_last = '',
				terminate = '',
				disconnect = '',
			},
		},
		expand_lines = true,
		layouts = {
			{
				elements = {
					{ id = 'console', size = 0.5 },
					{ id = 'repl', size = 0.5 },
				},
				position = 'left',
				size = 50,
			},
			{
				elements = {
					{ id = 'scopes', size = 0.50 },
					{ id = 'breakpoints', size = 0.20 },
					{ id = 'stacks', size = 0.15 },
					{ id = 'watches', size = 0.15 },
				},
				position = 'bottom',
				size = 15,
			},
		},
	},
	config = function(_, opts)
		require('dapui').setup(opts)

		local listener = require('dap').listeners
		listener.after.event_initialized['dapui_config'] = function()
			require('dapui').open()
		end
		listener.before.event_terminated['dapui_config'] = function()
			require('dapui').close()
		end
		listener.before.event_exited['dapui_config'] = function()
			require('dapui').close()
		end
		vim.keymap.set('n', '<localleader>T', function()
			require('dapui').toggle()
		end, { desc = 'Toggle DAP UI' })

		-- REPL completions
		require('cmp').setup({
			enabled = function()
				return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
			end,
		})

		require('cmp').setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
			sources = {
				{ name = 'dap' },
			},
		})
	end,
}
