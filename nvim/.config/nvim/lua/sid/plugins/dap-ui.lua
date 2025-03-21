return {
	'rcarriga/nvim-dap-ui',
	lazy = true,
	dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio', 'rcarriga/cmp-dap' },
	opts = {
		mappings = { expand = { '<CR>', '<2-LeftMouse>' }, open = 'o', remove = 'd', edit = 'e', repl = 'r' },
		force_buffers = false,
		element_mappings = { close = { 'q', '<Esc>' } },
		floating = {
			width = 50,
			height = 50,
			mappings = { close = { 'q', '<Esc>' } },
			border = { enable = true, focusable = true, highlight = 'Normal' },
		},
		render = { show_on = 'never', indent = 2 },
		border = { enable = true, focusable = true, highlight = 'Normal' },
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
		expand_lines = false,
	},
  keys = {
    { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
  },
	config = function(_, opts)
		local dap = require('dap')
		local dapui = require('dapui')
		dapui.setup(opts)
		dap.listeners.after.event_initialized['dapui_config'] = function()
			dapui.open({})
		end
		dap.listeners.before.event_terminated['dapui_config'] = function()
			dapui.close({})
		end
		dap.listeners.before.event_exited['dapui_config'] = function()
			dapui.close({})
		end
	end,
}
