return {
	"crnvl96/lazydocker.nvim",
	cmd = {
		"LazyDocker",
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("lazydocker").setup({})
	end,
  lazy = true,
	keys = {
		{ "<leader>ld", "<cmd>LazyDocker<cr>", desc = "Toggle LazyDocker" },
	},
}
