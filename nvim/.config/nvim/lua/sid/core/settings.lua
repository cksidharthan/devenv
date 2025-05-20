vim.cmd('let g:netrw_liststyle = 3')

local opt = vim.opt

-- set nocompatible
opt.compatible = false

opt.relativenumber = true
opt.number = true
opt.incsearch = true
opt.hlsearch = true
opt.showmode = true

opt.swapfile = false -- don't create swap files
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to space
opt.autoindent = true -- copy indent from current line when starting a new one
opt.wrap = false
opt.laststatus = 3 -- global statusline 

-- make sure to not open old buffers when presesing escape key
opt.hidden = true -- allow hidden buffers
opt.autowrite = true -- automatically write before running commands
opt.autoread = true -- automatically read file if it was changed outside of vim
opt.updatetime = 300 -- time in ms to write swap file

-- disable escape key from opening old buffers
vim.api.nvim_set_keymap('n', '<Esc>', ':nohlsearch<CR>', { noremap = true, silent = true })
-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes that you want case sensitive
opt.cursorline = true -- to show a horizontal line on where the cursor is at

opt.termguicolors = true
opt.background = 'dark' -- colorschemes that can be light or dark will be made dark
opt.signcolumn = 'yes' -- show sign column so that text doesn't shift

opt.backspace = 'indent,eol,start' -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append('unnamedplus') -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- set the border of splits to be bold and thick
vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 'white', bold = false })
-- opt.foldenable = true
opt.foldmethod = 'indent'
vim.g.markdown_folding = 1 -- enable markdown folding
-- add fillchars to remove ~ and | from the border
opt.fillchars = {
	vert = '║', -- character to use for vertical splits
	fold = ' ', -- character to use for folds
	foldopen = '', -- character to use for open folds
	foldsep = ' ', -- character to use for separator in folds
	foldclose = '', -- character to use for close folds
	msgsep = '‾', -- character to use for message separators
	eob = ' ', -- character to use for the end of the buffer
	-- diff = "╱", -- character to use for diff mode
	-- Add or remove entries as needed
}

opt.foldcolumn = '1' -- '0' is not bad
opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
opt.foldlevelstart = 99
opt.foldenable = true

-- settings for colorscheme transparency
vim.cmd('hi NormalFloat ctermbg=NONE guibg=NONE')
vim.cmd('hi FloatTitle ctermbg=NONE guibg=NONE')
vim.cmd('hi FloatBorder ctermbg=NONE guibg=NONE')
vim.cmd('hi DiagnosticFloatingHint  ctermbg=NONE guibg=NONE guifg=#42E66C')
vim.cmd('hi DiagnosticFloatingInfo ctermbg=NONE guibg=NONE guifg=#0876c5')
vim.cmd('hi DiagnosticFloatingWarn ctermbg=NONE guibg=NONE guifg=#E8AB53')
vim.cmd('hi DiagnosticFloatingError ctermbg=NONE guibg=NONE guifg=#ff5189')
vim.cmd('set background=dark')

-- line number coloring
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#51B3EC', bold = true })
vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white', bold = true })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#FB508F', bold = true })
