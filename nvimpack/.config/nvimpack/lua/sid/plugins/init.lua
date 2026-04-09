-- This file is the plugin index for nvimpack.
-- It is easiest to read in groups: startup essentials first, then editor features,
-- then tools that are mostly on-demand.

-- Always-on foundation: icons, theme, and UI shell.
require('sid.plugins.mini')
require('sid.plugins.ui')
require('sid.plugins.pack-ui')
require('sid.plugins.smart-splits')

-- Load on first real editing activity.
require('sid.plugins.treesitter')
require('sid.plugins.lsp')
require('sid.plugins.gitsigns')
require('sid.plugins.statuscol')
require('sid.plugins.hlchunk')
require('sid.plugins.flash')
require('sid.plugins.conform')
require('sid.plugins.todo-comments')
require('sid.plugins.blink')
require('sid.plugins.copilot')
require('sid.plugins.mini-pairs')

-- UI helpers that can wait until startup settles.
require('sid.plugins.which-key')
require('sid.plugins.noice')

-- Mostly command/keymap-driven tools.
require('sid.plugins.nvim-tree')
require('sid.plugins.oil')
require('sid.plugins.telescope')
require('sid.plugins.lazygit')
