-- This file is the plugin index for nvimpack.
-- It is easiest to read in groups: startup essentials first, then editor features,
-- then tools that are mostly on-demand.

-- Always-on foundation: icons, theme, and UI shell.
require('sid.plugins.mini')
require('sid.plugins.ui')
require('sid.plugins.pack-ui')
require('sid.plugins.smart-splits')

-- Editor features: most self-lazy-load on BufReadPre / InsertEnter / FileType
-- via sid.pack. Requiring them here just registers their triggers.
require('sid.plugins.treesitter')
require('sid.plugins.render-markdown')
require('sid.plugins.lsp')
require('sid.plugins.gitsigns')
require('sid.plugins.statuscol')
require('sid.plugins.hlchunk')
require('sid.plugins.flash')
require('sid.plugins.conform')
require('sid.plugins.gopher')
require('sid.plugins.todo-comments')
require('sid.plugins.blink')
require('sid.plugins.blink-compat')
require('sid.plugins.copilot')
require('sid.plugins.mini-pairs')
require('sid.plugins.colorizer')

-- UI helpers that can wait until startup settles.
require('sid.plugins.which-key')
require('sid.plugins.noice')

-- Mostly command/keymap-driven tools.
require('sid.plugins.nvim-tree')
require('sid.plugins.oil')
require('sid.plugins.telescope')
require('sid.plugins.trouble')
require('sid.plugins.lazygit')
require('sid.plugins.grug-far')
require('sid.plugins.dap')
require('sid.plugins.dap-ui')
require('sid.plugins.mason')
