-- recommended settings
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/echanovski/mini.icons",
})

vim.keymap.set("n", "<leader>ee", "<CMD>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

require("nvim-tree").setup({
	view = {
		width = 35,
		relativenumber = false,
	},
	disable_netrw = true,
	hijack_netrw = true,
	hijack_cursor = true,
	hijack_unnamed_buffer_when_opening = false,
	sync_root_with_cwd = true,
	update_focused_file = {
		enable = true,
		update_root = false,
	},
	-- change folder arrow icons
	renderer = {
		--  add a space in front of the folder name and the previous folder icon
		root_folder_modifier = ":t",
		indent_markers = {
			enable = true,
		},
		icons = {
			glyphs = {
				default = "󰈚 ",
				symlink = " ",
				folder = {
					default = " ",
					empty = " ",
					empty_open = " ",
					open = " ",
					symlink = " ",
					symlink_open = " ",
					arrow_open = "▼ ",
					arrow_closed = "▶ ",
				},
				git = {
					unstaged = "✗ ",
					staged = "✓ ",
					unmerged = " ",
					renamed = "➜",
					untracked = "★ ",
					deleted = "  ",
					ignored = " ◌ ",
				},
			},
		},
	},

	--disable window_ticker for explorer to work well with window splits
	actions = {
		open_file = {
			window_picker = {
				enable = true,
			},
			resize_window = true,
		},
	},
	filters = {
		custom = { ".DS_Store", ".trunk", ".vscode", "node_modules" },
	},
	git = {
		ignore = false,
	},
})
