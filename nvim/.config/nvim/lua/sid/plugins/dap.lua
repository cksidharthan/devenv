-- luacheck: push ignore foo
return {
	-- NOTE: Yes, you can install new plugins here!
	'mfussenegger/nvim-dap',
	lazy = true,
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Installs the debug adapters for you
		'williamboman/mason.nvim',
		'jay-babu/mason-nvim-dap.nvim',
		'theHamsta/nvim-dap-virtual-text',

		-- Add your own debuggers here
		'leoluz/nvim-dap-go',
	},
	config = function()
		require('nvim-dap-virtual-text').setup({
			enabled = true, -- enable this plugin (the default)
			enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
			highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
			highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
			show_stop_reason = true, -- show stop reason when stopped for exceptions
			commented = false, -- prefix virtual text with comment string
			only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
			all_references = false, -- show virtual text on all all references of the variable (not only definitions)
			clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
			--- A callback that determines how a variable is displayed or whether it should be omitted
			--- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
			--- @param buf number
			--- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
			--- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
			--- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
			--- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
			display_callback = function(variable, buf, stackframe, node, options)
				-- by default, strip out new line characters
				if options.virt_text_pos == 'eol' then
					return ' = ' .. variable.value:gsub('%s+', ' ')
				else
					return variable.name .. ' = ' .. variable.value:gsub('%s+', ' ')
				end
			end,
			-- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
			virt_text_pos = vim.fn.has('nvim-0.10') == 1 and 'eol',

			-- experimental features:
			all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
			virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
			virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
			-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
		})

		require('mason-nvim-dap').setup({
			automatic_installation = true,
			handlers = {},
			ensure_installed = {
				'delve',
			},
		})

		require('dap-go').setup()
	end,
	keys = {
		{
			'<leader>ds',
			function()
				require('dap').continue()
			end,
			desc = 'Debug: Start/Continue',
			mode = 'n',
		},
		{
			'<leader>dl',
			function()
				require('dap').run_last()
			end,
			desc = 'Debug: Last',
			mode = 'n',
		},
		{
			'<F5>',
			function()
				require('dap').step_into()
			end,
			desc = 'Debug: Step Into',
			mode = 'n',
		},
		{
			'<F2>',
			function()
				require('dap').step_over()
			end,
			desc = 'Debug: Step Over',
			mode = 'n',
		},
		{
			'<F3>',
			function()
				require('dap').step_out()
			end,
			desc = 'Debug: Step Out',
			mode = 'n',
		},
		{
			'<leader>b',
			function()
				require('dap').toggle_breakpoint()
			end,
			desc = 'Debug: Toggle Breakpoint',
			mode = 'n',
		},
		{
			'<F10',
			function()
				require('dap').stop()
			end,
			desc = 'Debug: Stop Debugging',
			mode = 'n',
		},
		{
			'<leader>B',
			function()
				require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
			end,
			desc = 'Debug: Set Breakpoint',
			mode = 'n',
		},
		{
			'<F10>',
			function()
				require('dap').close()
			end,
			desc = 'Debug: Stop Debugging',
			mode = 'n',
		},
		{
			'<leader>dx',
			function()
				require('dap').disconnect()
			end,
			desc = 'Debug: Stop',
			mode = 'n',
		},
		{
			'<leader>du',
			function()
				require('dapui').toggle()
			end,
			desc = 'Toggle Debug UI',
			mode = 'n',
		},
		{
			'<leader>dt',
			function()
				require('dap-go').debug_test()
			end,
			desc = 'Debug: Test',
			mode = 'n',
		},
		{
			'<leader>rt',
			function()
				require('dap-go').debug_test_nearest()
			end,
			desc = 'Run: Test Nearest',
			mode = 'n',
		},
		{
			'<leader>rf',
			function()
				require('dap-go').run()
			end,
			desc = 'Run: Function',
			mode = 'n',
		},
	},
}
