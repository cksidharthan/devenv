local opt = vim.opt

-- NvimTree replaces netrw in this config, so disable netrw up front.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.markdown_folding = 1

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false
opt.showmode = false

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.termguicolors = true
opt.background = 'dark'
opt.signcolumn = 'yes'
opt.laststatus = 3

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.clipboard:append('unnamedplus')
opt.splitright = true
opt.splitbelow = true

opt.swapfile = false
opt.undofile = true
opt.updatetime = 250
opt.timeout = true
opt.timeoutlen = 300
opt.confirm = true
opt.scrolloff = 4
opt.sidescrolloff = 8

opt.foldmethod = 'indent'
opt.foldcolumn = '1'
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars = {
	eob = ' ',
	fold = ' ',
	foldopen = '',
	foldclose = '',
	foldsep = ' ',
	msgsep = '‾',
}

local highlight_group = vim.api.nvim_create_augroup('sid-ui-highlights', { clear = true })

local function apply_ui_highlights()
	vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 'white', bold = false })
	vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
	vim.api.nvim_set_hl(0, 'FloatTitle', { bg = 'NONE' })
	vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' })
	vim.api.nvim_set_hl(0, 'DiagnosticFloatingHint', { bg = 'NONE', fg = '#42E66C' })
	vim.api.nvim_set_hl(0, 'DiagnosticFloatingInfo', { bg = 'NONE', fg = '#0876c5' })
	vim.api.nvim_set_hl(0, 'DiagnosticFloatingWarn', { bg = 'NONE', fg = '#E8AB53' })
	vim.api.nvim_set_hl(0, 'DiagnosticFloatingError', { bg = 'NONE', fg = '#ff5189' })
	vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#51B3EC', bold = true })
	vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white', bold = true })
	vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#FB508F', bold = true })
end

vim.api.nvim_create_autocmd('ColorScheme', {
	group = highlight_group,
	callback = apply_ui_highlights,
})

vim.api.nvim_create_autocmd('User', {
	group = highlight_group,
	pattern = 'NvThemeReload',
	callback = apply_ui_highlights,
})

apply_ui_highlights()
