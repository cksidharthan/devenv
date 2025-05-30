return {
	"NvChad/nvim-colorizer.lua",
  event = "BufReadPre",
  enabled = false,
	config = function()
		require("colorizer").setup({
			user_default_options = {
				names = false,
        tailwind = true,
			},
		})
	end,
}
