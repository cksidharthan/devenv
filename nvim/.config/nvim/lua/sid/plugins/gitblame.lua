return {
	"f-person/git-blame.nvim",
	cmd = "GitBlameToggle",
  lazy = true,
	opts = {},
	keys = {
		{ "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
	},
}
