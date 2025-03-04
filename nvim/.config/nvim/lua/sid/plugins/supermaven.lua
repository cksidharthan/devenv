-- :SupermavenStart    start supermaven-nvim
-- :SupermavenStop     stop supermaven-nvim
-- :SupermavenRestart  restart supermaven-nvim
-- :SupermavenToggle   toggle supermaven-nvim
-- :SupermavenStatus   show status of supermaven-nvim
-- :SupermavenUseFree  switch to the free version
-- :SupermavenUsePro   switch to the pro version
-- :SupermavenLogout   log out of supermaven
-- :SupermavenShowLog  show logs for supermaven-nvim
-- :SupermavenClearLog clear logs for supermaven-nvim
return {
	'supermaven-inc/supermaven-nvim',
  lazy = true,
	config = function()
		require('supermaven-nvim').setup({
      ignore_filetypes = { env = false },
      use_free = false,
    })
	end,
  cmds = {
    "SupermavenStart",
    "SupermavenStop",
    "SupermavenRestart",
    "SupermavenToggle",
    "SupermavenStatus",
  },
  keys = {
    { "<leader>smt", "<cmd>SupermavenToggle<cr>", desc = "Toggle Supermaven" },
    { "<leader>sme", "<cmd>SupermavenStart<cr>", desc = "Enable Supermaven" },
    { "<leader>smd", "<cmd>SupermavenStop<cr>", desc = "Disable Supermaven" },
  }
}
