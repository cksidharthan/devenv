return {
  'kristijanhusak/vim-dadbod-ui',
  event = "VeryLazy",
  dependencies = {
    { 'tpope/vim-dadbod',                     lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
  end,
  config = function()
    local keymap = vim.keymap
    keymap.set("n", "<leader>dbu", "<cmd>DBUIToggle<CR>", { desc = "Toggle DBUI" })
    keymap.set("n", "<leader>dba", "<cmd>DBUIAddConnection<CR>", { desc = "Add DB Connection" })
    keymap.set("n", "<leader>dbf", "<cmd>DBUIFindBuffer<CR>", { desc = "Find DB Buffer" })
  end,
}
