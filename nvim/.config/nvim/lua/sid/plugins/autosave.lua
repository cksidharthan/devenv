return {
	"Pocco81/auto-save.nvim",
	event = "BufReadPre",
	config = function()
		require("auto-save").setup({})
	end,
}
