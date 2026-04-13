local pack = require('sid.pack')

local load_trouble = pack.loader('trouble', {
  'https://github.com/folke/trouble.nvim',
}, function()
  require('trouble').setup({})
end)

pack.command('Trouble', load_trouble, { nargs = '*', desc = 'Toggle Trouble' })

vim.keymap.set('n', '<leader>xx', function()
  load_trouble()
  vim.cmd('Trouble diagnostics toggle')
end, { desc = 'Diagnostics (Trouble)' })

vim.keymap.set('n', '<leader>xX', function()
  load_trouble()
  vim.cmd('Trouble diagnostics toggle filter.buf=0')
end, { desc = 'Buffer Diagnostics (Trouble)' })

vim.keymap.set('n', '<leader>cs', function()
  load_trouble()
  vim.cmd('Trouble symbols toggle focus=false')
end, { desc = 'Symbols (Trouble)' })

vim.keymap.set('n', '<leader>cl', function()
  load_trouble()
  vim.cmd('Trouble lsp toggle focus=false win.position=right')
end, { desc = 'LSP Definitions / references / ... (Trouble)' })

vim.keymap.set('n', '<leader>xL', function()
  load_trouble()
  vim.cmd('Trouble loclist toggle')
end, { desc = 'Location List (Trouble)' })

vim.keymap.set('n', '<leader>xQ', function()
  load_trouble()
  vim.cmd('Trouble qflist toggle')
end, { desc = 'Quickfix List (Trouble)' })
