-- luacheck: push ignore foo
return {
	-- NOTE: Yes, you can install new plugins here!
	'mfussenegger/nvim-dap',
	lazy = true,
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Installs the debug adapters for you
		'williamboman/mason.nvim',
		{
			'jay-babu/mason-nvim-dap.nvim',
			dependencies = 'mason.nvim',
			cmd = { 'DapInstall', 'DapUninstall' },
			opts = {
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
          "delve",
          "go-debug-adapter"
				},
			},
			-- mason-nvim-dap is loaded when nvim-dap loads
			config = function() end,
		},
		-- {
		-- 	'theHamsta/nvim-dap-virtual-text',
		-- 	opts = {},
		-- },
		-- Add your own debuggers here
		'leoluz/nvim-dap-go',
	},
	config = function()
		require('dap-go').setup()
	end,
	keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
	},
}
