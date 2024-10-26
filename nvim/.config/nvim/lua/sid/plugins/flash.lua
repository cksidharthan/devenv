return {
	"folke/flash.nvim",
	event = "BufReadPre",
	opts = {
		modes = {
			search = {
				enabled = true,
			},
		},
	},
}
