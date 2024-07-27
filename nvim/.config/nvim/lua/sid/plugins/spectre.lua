-- use Telescope find string search using <leader>fs
-- send the list to quickfix list using Ctrl + q
-- do :cfdo %s/stringOne/stringTwo/gc | update | bd     ---- update is to
-- save the buffer, bd is to delete the buffers after replacing.

return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("spectre").setup({
			replace_engine = {
				["sed"] = {
					cmd = "sed",
					args = {
						"-i",
						"",
						"-E",
					},
				},
			},
		})
	end,
	lazy = true,
	keys = {
		{
			"<leader>Rr",
			function()
				require("spectre").toggle()
			end,
			desc = "Toggle search and replace",
		},
		{
			"<leader>Rw",
			mode = { "v", "n" },
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Search word",
		},
		{
			"<leader>Rf",
			function()
				require("spectre").open_file_search({ select_word = true })
			end,
			desc = "Search in current file",
		},
	},
}
