vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.base46_cache = vim.fs.joinpath(vim.fn.stdpath('data'), 'base46_cache') .. '/'

require('sid.core.options')
require('sid.core.autocmds')
require('sid.core.keymaps')
require('sid.pack')
require('sid.plugins')
