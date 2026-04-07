vim.pack.add({
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	{
		src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
		-- should i add build = make as i did in lazy
	},
	"https://github.com/echasnovski/mini.icons",
})

require("telescope").load_extension('fzf')
require("telescope").load_extension("noice")
require("telescope").load_extension('notify')
require("telescope").setup({
	prompt_prefix = " 🚀 ",
	layout_strategy = "horizontal",
	layout_config = {
		horizontal = {
			-- prompt_position = "top",
		},
	},
	path_display = { "truncate" },
	mappings = {
		i = {
			["<C-k>"] = require('telescope.actions').move_selection_previous, -- move to previous result
			["<C-j>"] = require('telescope.actions').move_selection_next, -- move to next result
			["<C-q>"] = require('telescope.actions').smart_send_to_qflist + require('telescope.actions').open_qflist,
		},
	},
	file_ignore_patterns = {
		"^./.git/",
		"^*/node_modules/",
		"^vendor/",
		"^.nuxt/",
		"^.vscode/",
		"^venv/",
		"^.venv/",
		"^__pycache__/",
		"^.idea/",
	},
})

-- File navigation
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope colorscheme<CR>", { desc = "Change Colorscheme" })

vim.keymap.set("n", "<leader>ff",
  function()
    require("telescope.builtin").find_files({
      find_command = {
        "rg", "--files", "--hidden",
        "-g", "!.git",
        "-g", "!vendor",
        "-g", "!node_modules",
        "-u"
      }
    })
  end,
  { desc = "Fuzzy find files in Current working directory" }
)

vim.keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<CR>", { desc = "Fuzzy find git files" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fn", "<cmd>Telescope notify<CR>", { desc = "Notifications" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Open buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })

vim.keymap.set("n", "<leader>fib",
  function()
    require("telescope.builtin").current_buffer_fuzzy_find({
      sorting_strategy = "ascending"
    })
  end,
  { desc = "Fuzzy find in current buffer" }
)

vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fo", "<cmd>TodoTelescope<CR>", { desc = "TODOs" })
vim.keymap.set("n", "<leader>ft", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })

-- LSP navigation
vim.keymap.set("n", "gd", function()
  require("telescope.builtin").lsp_definitions()
end, { desc = "[G]oto [D]efinition" })

vim.keymap.set("n", "gr", function()
  require("telescope.builtin").lsp_references()
end, { desc = "[G]oto [R]eferences" })

vim.keymap.set("n", "gi", function()
  require("telescope.builtin").lsp_implementations()
end, { desc = "[G]oto [I]mplementation" })

vim.keymap.set("n", "<leader>D", function()
  require("telescope.builtin").lsp_type_definitions()
end, { desc = "Type Definition" })

vim.keymap.set("n", "<leader>ds", function()
  require("telescope.builtin").lsp_document_symbols()
end, { desc = "Document Symbols" })

vim.keymap.set("n", "<leader>ws", function()
  require("telescope.builtin").lsp_dynamic_workspace_symbols()
end, { desc = "Workspace Symbols" })

-- LSP actions
vim.keymap.set("n", "<leader>rn", function()
  vim.lsp.buf.rename()
end, { desc = "Rename" })

vim.keymap.set({ "n", "x" }, "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "Code Action" })

vim.keymap.set("n", "gD", function()
  vim.lsp.buf.declaration()
end, { desc = "Goto Declaration" })
