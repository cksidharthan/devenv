return {
  "barrett-ruth/live-server.nvim",
  lazy = true,
  cmd = {
    "LiveServerStart",
    "LiveServerStop",
  },
  build = 'pnpm add -g live-server',
  config = function()
    require("live-server").setup({
      settings = {
        port = 8080,
        host = "localhost",
        root = vim.fn.getcwd(),
        wait = 1000,
        log = false,
      },
    })
    vim.g.live_server_open_in_browser = 1
    vim.g.live_server_default_browser = "arc"
  end,
}
