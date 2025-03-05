return {
	'm4xshen/hardtime.nvim',
	sdependencies = { 'MunifTanjim/nui.nvim' },
  keys = {
    { "<leader>hd", "<cmd>Hardtime disable<CR>", desc = "Disable Vim Hardtime" },
    { "<leader>he", "<cmd>Hardtime enable<CR>", desc = "Enable Vim Hardtime" },
  },
	opts = {},
}
