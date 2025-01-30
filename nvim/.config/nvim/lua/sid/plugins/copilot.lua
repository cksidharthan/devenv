return {
	"zbirenbaum/copilot.lua",
	event = "InsertEnter",
	keys = {
		{ "<leader>cod", "<cmd>Copilot disable<CR>", desc = "Copilot disable" },
		{ "<leader>coe", "<cmd>Copilot enable<CR>", desc = "Copilot enable" },
	},
	opts = {
		panel = {
			enabled = false,
			auto_refresh = false,
			keymap = {
				jump_prev = "[[",
				jump_next = "]]",
				accept = "<CR>",
				refresh = "gr",
				open = "<M-CR>",
			},
			layout = {
				position = "bottom", -- | top | left | right
				ratio = 0.4,
			},
		},
		suggestion = {
			enabled = false,
			auto_trigger = true,
			debounce = 75,
			keymap = {
        -- make tab to accept suggestion
				accept = "<Tab>",
				dismiss = "<M-h>",
				accept_word = false,
				accept_line = false,
				next = "<M-]>",
				prev = "<M-[>",
			},
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
