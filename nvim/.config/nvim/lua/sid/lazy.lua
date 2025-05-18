-- put this in your main init.lua file ( before lazy setup )
vim.g.base46_cache = vim.fn.stdpath('data') .. '/base46_cache/'

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable branch
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{ import = 'sid.plugins' },
	{ import = 'sid.plugins.nvchad' },
}, {
	-- defaults = { lazy = true },
	install = {
		-- install missing plugins on startup. This doesn't increase startup time.
		missing = true,
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = false,
		notify = false, -- get a notification when changes are found
	},
	checker = {
		enabled = false,
		notify = false,
	},
	debug = false,
	ui = {
		position = 'bottom',
	},
	performance = {
		rtp = {
			disabled_plugins = {
				'2html_plugin',
				'tohtml',
				'getscrip',
				'getscripPlugin',
				'gzip',
				'logipat',
				'netrw',
				'netrwPlugin',
				'netrwSettings',
				'netrwFileHandlers',
				'matchit',
				'tar',
				'tarPlugin',
				'rrhelper',
				'spellfile_plugin',
				'vimball',
				'vimballPlugin',
				'zip',
				'zipPlugin',
				'tutor',
				'rplugin',
				'syntax',
				'synmenu',
				'optwin',
				'compiler',
				'bugreport',
				'ftplugin',
			},
		},
	},
})

-- (method 2, for non lazyloaders) to load all highlights at once
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
	dofile(vim.g.base46_cache .. v)
end

-- to color the buffer separators
vim.api.nvim_command('highlight WinSeparator guifg=#ffff99')
