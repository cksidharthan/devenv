local M = {}
local state = {}

local function plugin_changed(kind)
	return kind == 'install' or kind == 'update'
end

vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(event)
		local data = event.data
		local name, kind = data.spec.name, data.kind

		if name == 'telescope-fzf-native.nvim' and plugin_changed(kind) then
			local result = vim.system({ 'make' }, { cwd = data.path }):wait()
			if result.code ~= 0 then
				vim.notify('Failed to build telescope-fzf-native.nvim', vim.log.levels.WARN)
			end
			return
		end

		if name == 'nvim-treesitter' and plugin_changed(kind) then
			if not data.active then
				vim.cmd.packadd('nvim-treesitter')
			end
			pcall(vim.cmd, 'TSUpdate')
			return
		end

		if name == 'base46' and plugin_changed(kind) then
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
	local defaults = { confirm = false, load = true }
	vim.pack.add(specs, vim.tbl_extend('force', defaults, opts or {}))
end

function M.loader(id, specs, setup, opts)
	return function()
		local plugin = state[id]
		if not plugin then
			M.add(specs, opts)
			plugin = { configured = false }
			state[id] = plugin
		end

		if setup and not plugin.configured then
			plugin.configured = true
			setup()
		end
	end
end

function M.on_event(events, id, specs, setup, autocmd)
	local load = M.loader(id, specs, setup)
	local options = vim.tbl_extend('force', { once = true }, autocmd or {})
	options.callback = load
	vim.api.nvim_create_autocmd(events, options)
	return load
end

function M.later(id, specs, setup)
	local load = M.loader(id, specs, setup)
	vim.schedule(load)
	return load
end

function M.command(name, load, opts)
	local user_opts = vim.tbl_extend('force', { nargs = '*', bang = true }, opts or {})

	vim.api.nvim_create_user_command(name, function(ctx)
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
