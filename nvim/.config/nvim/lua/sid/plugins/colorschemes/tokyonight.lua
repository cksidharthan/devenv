return {
  "folke/tokyonight.nvim",
  event = "VeryLazy",
  priority = 1000,
  config = function()
    vim.cmd("colorscheme tokyonight-night")
  end,
  opts = {},
}
