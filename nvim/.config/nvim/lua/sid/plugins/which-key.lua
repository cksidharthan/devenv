-- this plugin helps you to remember the keybindings in neovim by showing a popup with the possible keybindings after pressing a keybinding
return {
	"folke/which-key.nvim",
  event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
  config = function()
    require("which-key").setup({})
  end
}
