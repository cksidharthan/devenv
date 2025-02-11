local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable branch
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "sid.plugins" },
	{ import = "sid.plugins.lsp" },
	{ import = "sid.plugins.colorschemes" },
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
		position = "bottom",
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
