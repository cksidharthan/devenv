-- This module is the glue around Neovim 0.12's vim.pack API.
-- Start here if you want to understand when plugins load.

local M = {}
-- Track whether a lazy plugin has already been added/configured in this session.
local state = {}

local function plugin_changed(kind)
	return kind == 'install' or kind == 'update'
end

vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(event)
		local data = event.data
		local name, kind = data.spec.name, data.kind

		-- Some plugins need a post-install build step because vim.pack only fetches them.
		if name == 'telescope-fzf-native.nvim' and plugin_changed(kind) then
			local result = vim.system({ 'make' }, { cwd = data.path }):wait()
			if result.code ~= 0 then
				vim.notify('Failed to build telescope-fzf-native.nvim', vim.log.levels.WARN)
			end
			return
		end

		if name == 'nvim-treesitter' and plugin_changed(kind) then
			-- TSUpdate expects the plugin on runtimepath, so packadd it first if needed.
			if not data.active then
				vim.cmd.packadd('nvim-treesitter')
			end
			pcall(vim.cmd, 'TSUpdate')
			return
		end

		if name == 'base46' and plugin_changed(kind) then
			-- Refresh cached highlights after theme updates so UI plugins stay in sync.
			if not data.active then
				vim.cmd.packadd('base46')
			end
			pcall(function()
				require('base46').load_all_highlights()
			end)
		end
	end,
})

function M.add(specs, opts)
	-- Most callers want immediate loading and no interactive confirmation.
	local defaults = { confirm = false, load = true }
	vim.pack.add(specs, vim.tbl_extend('force', defaults, opts or {}))
end

function M.loader(id, specs, setup, opts)
	return function()
		local plugin = state[id]
		if not plugin then
			-- First call downloads/adds the plugin(s) and remembers that this loader ran.
			M.add(specs, opts)
			plugin = { configured = false }
			state[id] = plugin
		end

		if setup and not plugin.configured then
			-- Run setup once, even if several commands/maps call the same loader.
			plugin.configured = true
			setup()
		end
	end
end

function M.on_event(events, id, specs, setup, autocmd)
	-- Lazy-load a plugin the first time one of these editor events fires.
	local load = M.loader(id, specs, setup)
	local options = vim.tbl_extend('force', { once = true }, autocmd or {})
	options.callback = load
	vim.api.nvim_create_autocmd(events, options)
	return load
end

function M.later(id, specs, setup)
	-- Use this for plugins that are useful, but not important to startup time.
	local load = M.loader(id, specs, setup)
	vim.schedule(load)
	return load
end

function M.command(name, load, opts)
	-- Define a placeholder command that loads the plugin, then re-runs the real command.
	local user_opts = vim.tbl_extend('force', { nargs = '*', bang = true }, opts or {})

	vim.api.nvim_create_user_command(name, function(ctx)
		-- Remove the placeholder first so the second vim.cmd() hits the plugin's real command.
		pcall(vim.api.nvim_del_user_command, name)
		load()

		local command = name
		if ctx.bang then
			command = command .. '!'
		end
		if ctx.args ~= '' then
			command = command .. ' ' .. ctx.args
		end

		vim.cmd(command)
	end, user_opts)
end

return M
