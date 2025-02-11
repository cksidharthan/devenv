return {
	"akinsho/bufferline.nvim",
	dependencies = "echasnovski/mini.icons",
  event = "BufReadPre",
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				show_tab_indicators = true,
        show_close_icon = true,
        color_icons = true,
        indicator = {
          style = "icon",
        },
        buffer_close_icon = 'Ⅹ ',
        close_icon = 'Ⅹ ',
				diagnostics = "nvim_lsp",
        separator_style = "thick",
				offsets = {
					{
						filetype = "NvimTree",
						text = "File Explorer",
						text_align = "center",
						separator = false,
					},
				},
			},
		})
	end,
}
