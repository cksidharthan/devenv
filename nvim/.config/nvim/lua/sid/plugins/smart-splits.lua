local term_program = (vim.env.TERM_PROGRAM or ''):lower()
local term = (vim.env.TERM or ''):lower()
local is_kitty = vim.env.KITTY_LISTEN_ON ~= nil or term == 'xterm-kitty'
local is_wezterm = term_program == 'wezterm'
local multiplexer = is_wezterm and 'wezterm' or is_kitty and 'kitty' or nil

return {
  'mrjones2014/smart-splits.nvim',
  build = './kitty/install-kittens.bash',
  -- we cant lazy load this plugin as navigation between kitty and nvim buffer is not working properly
  lazy = false,
  enabled = multiplexer ~= nil,
  init = function()
    vim.g.smart_splits_multiplexer_integration = multiplexer
  end,
  config = function()
    local smart_splits = require('smart-splits')

    vim.keymap.set('n', '<A-h>', smart_splits.resize_left)
    vim.keymap.set('n', '<A-j>', smart_splits.resize_down)
    vim.keymap.set('n', '<A-k>', smart_splits.resize_up)
    vim.keymap.set('n', '<A-l>', smart_splits.resize_right)
    -- moving between splits
    vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left)
    vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down)
    vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up)
    vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right)
    vim.keymap.set('n', '<C-\\>', smart_splits.move_cursor_previous)

    smart_splits.setup()
  end
}
