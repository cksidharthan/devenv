-- smart-splits restores pane navigation between Neovim and the terminal multiplexer.
-- Only enable it when running inside a supported terminal.

local term_program = (vim.env.TERM_PROGRAM or ''):lower()
local term = (vim.env.TERM or ''):lower()
local is_kitty = vim.env.KITTY_LISTEN_ON ~= nil or term == 'xterm-kitty'
local is_wezterm = term_program == 'wezterm'
local multiplexer = is_wezterm and 'wezterm' or is_kitty and 'kitty' or nil

if not multiplexer then
	return
end

local pack = require('sid.pack')
local home_config = vim.fs.joinpath(vim.env.HOME or vim.fn.expand('~'), '.config')

vim.g.smart_splits_multiplexer_integration = multiplexer

vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(event)
		local data = event.data
		if data.spec.name ~= 'smart-splits.nvim' then
			return
		end
		if data.kind ~= 'install' and data.kind ~= 'update' then
			return
		end
		if multiplexer ~= 'kitty' then
			return
		end

		-- Install kitty helpers into the real kitty config even if Neovim itself is
		-- running with an alternate XDG_CONFIG_HOME.
		local result = vim.system({
			'bash',
			'./kitty/install-kittens.bash',
		}, {
			cwd = data.path,
			env = {
				XDG_CONFIG_HOME = home_config,
			},
		}):wait()
		if result.code ~= 0 then
			vim.notify('Failed to install smart-splits kitty helpers', vim.log.levels.WARN)
		end
	end,
})

pack.startup({
	'https://github.com/mrjones2014/smart-splits.nvim',
})

local smart_splits = require('smart-splits')

smart_splits.setup()

vim.keymap.set('n', '<A-h>', smart_splits.resize_left, { desc = 'Resize split left' })
vim.keymap.set('n', '<A-j>', smart_splits.resize_down, { desc = 'Resize split down' })
vim.keymap.set('n', '<A-k>', smart_splits.resize_up, { desc = 'Resize split up' })
vim.keymap.set('n', '<A-l>', smart_splits.resize_right, { desc = 'Resize split right' })

vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left, { desc = 'Focus left split or pane' })
vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down, { desc = 'Focus lower split or pane' })
vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up, { desc = 'Focus upper split or pane' })
vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right, { desc = 'Focus right split or pane' })
vim.keymap.set('n', '<C-\\>', smart_splits.move_cursor_previous, { desc = 'Focus previous split or pane' })
