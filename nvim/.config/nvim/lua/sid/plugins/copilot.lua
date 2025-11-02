return {
	"zbirenbaum/copilot.lua",
	event = "InsertEnter",
  dependencies = {
    "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
  },
	keys = {
		{ "<leader>cod", "<cmd>Copilot disable<CR>", desc = "Copilot disable" },
		{ "<leader>coe", "<cmd>Copilot enable<CR>", desc = "Copilot enable" },
	},
	opts = {
		suggestion = {
      enabled = false,
		},
    copilot_model = "gpt-4o-copilot",
    panel = {
      enabled = false,
    },
		filetypes = {
			["."] = true,
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
	},
}
