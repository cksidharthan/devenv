return {
	"yetone/avante.nvim",
	version = false, -- set this if you want to always pull the latest change
  lazy = true,
	build = "make",
  cmd = {
    "AvanteAsk",
    "AvanteChat",
    "AvanteSwitchProvider",
    "AvanteToggle",
  },
	config = function()
		require("avante").setup({
			auto_suggestions_provider = "copilot",
			provider = "claude", -- Recommend using Claude
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-3-5-sonnet-20241022",
				temperature = 0,
				max_tokens = 4096,
			},
		})
	end,
	dependencies = {
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
