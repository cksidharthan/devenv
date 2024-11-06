return {
  'mrjones2014/smart-splits.nvim',
  event = "VeryLazy",
  dependencies = {
    'kwkarlwang/bufresize.nvim',
  },
  config = function()
    vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
    vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
    vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
    vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
    -- moving between splits
    vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
    vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
    vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
    vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
    vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
    require('smart-splits').setup({
      resize_mode = {
        silent = true,
        hooks = {
          on_enter = function()
            vim.notify('Entering resize mode')
          end,
          on_leave = function()
            require('bufresize').register()
            vim.notify('Exiting resize mode, bye')
          end,
        },
      },
    })
  end

}
