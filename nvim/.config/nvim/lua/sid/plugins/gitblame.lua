return {
  "f-person/git-blame.nvim",
  event = "VeryLazy",
  config = function()
    vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<CR>", { desc = "Toggle Git Blame information" })
  end
}
