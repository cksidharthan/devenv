return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
  event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"xiyaowong/telescope-emoji.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		telescope.load_extension("emoji")

		telescope.setup({
			defaults = {
				prompt_prefix = " 🚀 ",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						-- prompt_position = "top",
					},
				},
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to previous result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
				},
				file_ignore_patterns = { ".git/", "node_modules/", "vendor/", ".nuxt/", ".idea", ".vscode" },
			},
		})

		telescope.load_extension("fzf")

		local keymap = vim.keymap

		keymap.set("n", "<leader>fc", "<cmd>Telescope colorscheme<CR>", { desc = "Change Colorscheme" })

		keymap.set(
			"n",
			"<leader>ff",
			"<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git', '-u' }})<CR>",
			{ desc = "Fuzzy find files in Current working directory" }
		)
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Fuzzy find files in Recent files" })
    keymap.set("n", "<leader>fe", "<cmd>Telescope emoji<CR>", { desc = "Fuzzy find emojis" })
		keymap.set(
			"n",
			"<leader>fs",
			"<cmd>Telescope live_grep<CR>",
			{ desc = "Fuzzy string in Current working directory" }
		)
		-- add another keymap for listing open buffers
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Fuzzy find open buffers" })
		-- find todos
		keymap.set(
			"n",
			"<leader>en",
			"<cmd>Telescope find_files cwd=~/.config/nvim<CR>",
			{ desc = "Fuzzy find filetypes in Current working directory" }
		)
		keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Fuzzy find help tags" })
		keymap.set(
			"n",
			"<leader>fib",
			"<cmd>Telescope current_buffer_fuzzy_find sorting_strategy=ascending<CR>",
			{ desc = "Fuzzy find in current buffer" }
		)
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Fuzzy find keymaps" })
		-- add keymap for lsp symbols in the current buffer
		keymap.set(
			"n",
			"<leader>ft",
			"<cmd>Telescope lsp_document_symbols<CR>",
			{ desc = "Fuzzy find symbols and types in the current file" }
		)
	end,
}
