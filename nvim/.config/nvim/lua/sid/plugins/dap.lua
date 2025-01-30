-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	-- NOTE: Yes, you can install new plugins here!
	'mfussenegger/nvim-dap',
	lazy = true,
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Installs the debug adapters for you
		'williamboman/mason.nvim',
		'jay-babu/mason-nvim-dap.nvim',
		{ 'igorlfs/nvim-dap-view', opts = {} },
		'theHamsta/nvim-dap-virtual-text',

		-- Add your own debuggers here
		'leoluz/nvim-dap-go',
	},
	config = function()
		require('mason-nvim-dap').setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				'delve',
			},
		})

		-- Install golang specific config
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
			'<leader>B',
			function()
				require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
			end,
			desc = 'Debug: Set Breakpoint',
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
    {
      '<leader>du',
      function()
        require("dap-view").toggle()
      end,
      desc = 'Debug: Open Debug UI',
      mode = 'n',
    }
	},
}
