-- Shared non-plugin keymaps live here.
-- Plugin-specific maps stay next to the plugin so this file remains the editing baseline.

local map = vim.keymap.set

map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Clear highlight after a search without leaving normal mode.
map('n', '<Esc>', function()
	vim.cmd.nohlsearch()
end, { desc = 'Clear search highlight' })

map('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- File and buffer lifecycle.
map('n', '<leader>w', '<cmd>write<cr>', { desc = 'Write file' })
map('n', '<leader>wq', '<cmd>wq<cr>', { desc = 'Write and quit' })
map('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Quit window' })
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })
map('n', '<leader><leader>x', '<cmd>source %<cr>', { desc = 'Source current file' })
map('n', '<leader>re', '<cmd>edit!<cr>', { desc = 'Reload current file' })

-- Window management.
map('n', '<leader>sv', '<C-w>v', { desc = 'Split vertically' })
map('n', '<leader>sh', '<C-w>s', { desc = 'Split horizontally' })
map('n', '<leader>se', '<C-w>=', { desc = 'Equalize splits' })
map('n', '<leader>sx', '<cmd>close<cr>', { desc = 'Close split' })
map('n', '<leader>so', '<cmd>only<cr>', { desc = 'Close other splits' })
map('n', '<C-h>', '<C-w>h', { desc = 'Focus left split' })
map('n', '<C-j>', '<C-w>j', { desc = 'Focus lower split' })
map('n', '<C-k>', '<C-w>k', { desc = 'Focus upper split' })
map('n', '<C-l>', '<C-w>l', { desc = 'Focus right split' })
map('n', '<C-\\>', '<C-w>p', { desc = 'Focus previous split' })

-- Tab pages are used sparingly, but these keep them easy to manage.
map('n', '<leader>to', '<cmd>tabnew<cr>', { desc = 'New tab' })
map('n', '<leader>tx', '<cmd>tabclose<cr>', { desc = 'Close tab' })
map('n', '<leader>tn', '<cmd>tabnext<cr>', { desc = 'Next tab' })
map('n', '<leader>tp', '<cmd>tabprevious<cr>', { desc = 'Previous tab' })
map('n', '<leader>tf', '<cmd>tabnew %<cr>', { desc = 'Current buffer in new tab' })

-- Fast buffer cycling without reaching for commands.
map('n', '<Tab>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', 'bx', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })
map('n', 'bn', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', 'bp', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })

map('n', '<C-[>', '<C-t>', { desc = 'Jump back in tag stack' })

-- Keep motion/search centered so repeated navigation is easier to follow.
map('n', 'n', 'nzz', { silent = true })
map('n', 'N', 'Nzz', { silent = true })
map('n', 'yaf', 'va{Vy', { desc = 'Yank around function block' })
