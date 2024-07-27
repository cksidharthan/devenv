-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	-- NOTE: Yes, you can install new plugins here!
	"mfussenegger/nvim-dap",
	lazy = true,
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",

		-- Required dependency for nvim-dap-ui
		"nvim-neotest/nvim-nio",

		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		"theHamsta/nvim-dap-virtual-text",

		-- Add your own debuggers here
		"leoluz/nvim-dap-go",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		require("nvim-dap-virtual-text").setup({})

		require("mason-nvim-dap").setup({
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
			},
		})

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup({
			mappings = {
				-- Use a table to apply multiple mappings
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
			},
			force_buffers = false,
			element_mappings = {
				close = { "q", "<Esc>" },
			},
			floating = {
				max_height = nil,
				max_width = nil,
				mappings = {
					close = { "q", "<Esc>" },
				},
				border = {
					enable = true,
					focusable = true,
					highlight = "Normal",
				},
			},
			render = {
				show_on = "never",
				indent = 2,
			},
			border = {
				enable = true,
				focusable = true,
				highlight = "Normal",
			},
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			-- all the icons should be like jetbrains icons
			controls = {
				enabled = true,
				element = "repl",
				icons = {
					pause = "",
					play = "",
					step_into = "",
					step_over = "",
					step_out = "",
					step_back = "",
					run_last = "",
					terminate = "",
					disconnect = "",
				},
			},
			expand_lines = true,
			layouts = {
				{
					elements = {
						{
							id = "console",
							size = 0.5,
						},
						{
							id = "breakpoints",
							size = 0.5,
						},
						{
							id = "stacks",
							size = 0,
						},
						{
							id = "watches",
							size = 0,
						},
					},
					position = "left",
					size = 40,
				},
				{
					elements = {
						{
							id = "repl",
							size = 0.50,
						},
						{
							id = "scopes",
							size = 0.50,
						},
					},
					position = "bottom",
					size = 10,
				},
			},
		})

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		-- dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		-- dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- Install golang specific config
		require("dap-go").setup()
	end,
	keys = {
		{
			"<leader>ds",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
			mode = "n",
		},
    -- debug the last run debug
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "Debug: Last",
      mode = "n",
    },
		{
			"<F5>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
			mode = "n",
		},
		{
			"<F2>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
			mode = "n",
		},
		{
			"<F3>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
			mode = "n",
		},
		{
			"<leader>b",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
			mode = "n",
		},
		{
			"<leader>B",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Set Breakpoint",
			mode = "n",
		},
		{
			"<leader>dx",
			function()
				require("dap").disconnect()
			end,
			desc = "Debug: Stop",
			mode = "n",
		},
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle Debug UI",
			mode = "n",
		},
		{
			"<leader>dt",
			function()
				require("dap-go").debug_test()
			end,
			desc = "Debug: Test",
			mode = "n",
		},
	},
}
