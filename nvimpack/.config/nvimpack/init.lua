-- nvimpack keeps startup intentionally small.
-- Read this file top to bottom:
-- 1. global variables used by Neovim and NvChad/base46
-- 2. core editor behavior
-- 3. vim.pack helper functions
-- 4. plugin modules

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.base46_cache = vim.fs.joinpath(vim.fn.stdpath('data'), 'base46_cache') .. '/'

-- Core settings should exist before any plugin code runs.
require('sid.core.options')
require('sid.core.autocmds')
require('sid.core.keymaps')

-- Most plugin files use these helpers to lazy-load themselves.
require('sid.pack')

-- This final require fans out into one file per plugin area.
require('sid.plugins')
