-- to view vim help in a decorated way
return {
	"OXY2DEV/helpview.nvim",
	lazy = true,
	ft = "help",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
}
