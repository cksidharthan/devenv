-- This module is the glue around Neovim 0.12's vim.pack API.
-- It defines the small loader API that every plugin file in this config uses.
--
-- Preferred patterns:
--   pack.add(...)                  startup-critical plugins
--   pack.on_event(...)             load on first matching editor event
--   pack.later(...)                schedule after startup settles
--   local load_x = pack.loader(...)    reusable lazy loader
--   pack.command('Cmd', load_x)        lazy-safe user commands
--
-- Plugin files are expected to work by side effect when required from
-- sid.plugins.init. Prefer command shims over cross-module `require(...).load()`
-- calls so the file shape stays simple and uniform.

local M = {}
-- Track whether a lazy plugin has already been added/configured in this session.
-- Shape: state[id] = { configured = boolean }
local state = {}
local loader_meta = setmetatable({}, { __mode = 'k' })
local registry = {}

local function normalize_ui_spec(spec)
	spec = type(spec) == 'string' and { src = spec } or spec
	if type(spec) ~= 'table' or type(spec.src) ~= 'string' or spec.src == '' then
		return nil
	end

	local name = spec.name or spec.src:gsub('%.git$', '')
	name = (type(name) == 'string' and name or ''):match('[^/]+$') or ''
	if name == '' then
		return nil
	end

	return {
		name = name,
		src = spec.src,
		version = spec.version,
	}
end

local function normalize_ui_specs(specs)
	local normalized = {}
	for _, spec in ipairs(specs) do
		local item = normalize_ui_spec(spec)
		if item then
			normalized[#normalized + 1] = item
		end
	end
	return normalized
end

local function list_add_unique(list, value)
	if value and value ~= '' and not vim.tbl_contains(list, value) then
		list[#list + 1] = value
	end
end

local function get_registry_entry(spec)
	local entry = registry[spec.name]
	if not entry then
		entry = {
			name = spec.name,
			src = spec.src,
			version = spec.version,
			startup = false,
			later = false,
			events = {},
			commands = {},
			loader_ids = {},
		}
		registry[spec.name] = entry
	end

	entry.src = spec.src or entry.src
	if spec.version ~= nil then
		entry.version = spec.version
	end

	return entry
end

local function register_specs(specs, update)
	for _, spec in ipairs(normalize_ui_specs(specs)) do
		update(get_registry_entry(spec), spec)
	end
end

local function attach_loader_metadata(load, update)
	local meta = loader_meta[load]
	if not meta then
		return
	end

	for _, spec in ipairs(meta.specs) do
		local entry = get_registry_entry(spec)
		list_add_unique(entry.loader_ids, meta.id)
		update(entry, spec)
	end
end

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
	-- Add one or more plugin specs immediately.
	--
	-- specs:
	--   The same list/table you would pass to vim.pack.add().
	-- opts:
	--   Additional vim.pack.add() options. They are merged with:
	--     { confirm = false, load = true }
	--
	-- Use this when a plugin must exist right now during startup.
	local defaults = { confirm = false, load = true }
	vim.pack.add(specs, vim.tbl_extend('force', defaults, opts or {}))
end

function M.startup(specs, opts)
	-- Register plugins as startup-loaded before adding them immediately.
	register_specs(specs, function(entry)
		entry.startup = true
	end)

	M.add(specs, opts)
end

function M.loader(id, specs, setup, opts)
	-- Create a stable one-shot loader function.
	--
	-- id:
	--   Unique cache key for this logical plugin group. Reuse the same id everywhere
	--   that should share one loaded/configured instance.
	-- specs:
	--   Plugin specs forwarded to M.add() the first time the loader is called.
	-- setup:
	--   Optional callback that runs once after the specs have been added.
	-- opts:
	--   Optional M.add()/vim.pack.add() options used only on the first load.
	--
	-- Returns:
	--   A function with no arguments. Calling it repeatedly is safe; plugin fetch/add
	--   happens once per session and setup() also runs at most once.
	register_specs(specs, function(entry)
		list_add_unique(entry.loader_ids, id)
	end)

	local load = function()
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

	loader_meta[load] = {
		id = id,
		specs = normalize_ui_specs(specs),
	}

	return load
end

function M.on_event(events, id, specs, setup, autocmd)
	-- Register an autocmd-backed lazy loader.
	--
	-- events:
	--   Event name or list of event names passed to nvim_create_autocmd().
	-- id/specs/setup:
	--   Same meaning as M.loader().
	-- autocmd:
	--   Extra autocmd options. By default this helper uses { once = true } so the
	--   triggering event only needs to happen once.
	--
	-- Returns:
	--   The underlying loader function, so callers can also force-load manually.
	events = type(events) == 'table' and events or { events }
	local load = M.loader(id, specs, setup)
	attach_loader_metadata(load, function(entry)
		for _, event in ipairs(events) do
			list_add_unique(entry.events, event)
		end
	end)
	local options = vim.tbl_extend('force', { once = true }, autocmd or {})
	options.callback = load
	vim.api.nvim_create_autocmd(events, options)
	return load
end

function M.later(id, specs, setup)
	-- Schedule a lazy loader to run on the next event loop tick.
	--
	-- This is useful for non-essential UI/helpers that should load shortly after
	-- startup without blocking init.lua.
	--
	-- Returns:
	--   The same one-shot loader function returned by M.loader().
	local load = M.loader(id, specs, setup)
	attach_loader_metadata(load, function(entry)
		entry.later = true
	end)
	vim.schedule(load)
	return load
end

function M.command(name, load, opts)
	-- Define a placeholder user command that bootstraps a lazy plugin.
	--
	-- name:
	--   Exact command name to stub before the real plugin command exists.
	-- load:
	--   Loader function, usually returned by M.loader()/M.on_event()/M.later().
	-- opts:
	--   User-command options. They are merged with { nargs = '*', bang = true }.
	--
	-- Behavior:
	--   1. Delete the placeholder command.
	--   2. Call load().
	--   3. Re-run the original command line so the plugin's real command handles it.
	--
	-- This keeps both keymaps and :Commands lazy-safe without duplicating load logic.
	local user_opts = vim.tbl_extend('force', { nargs = '*', bang = true }, opts or {})
	attach_loader_metadata(load, function(entry)
		list_add_unique(entry.commands, name)
	end)

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

function M.hint(load, metadata)
	-- Attach extra UI metadata to an existing loader when the trigger is custom
	-- rather than expressed through pack.command()/pack.on_event()/pack.later().
	attach_loader_metadata(load, function(entry)
		for _, command in ipairs(metadata.commands or {}) do
			list_add_unique(entry.commands, command)
		end

		for _, event in ipairs(metadata.events or {}) do
			list_add_unique(entry.events, event)
		end

		if metadata.startup then
			entry.startup = true
		end
		if metadata.later then
			entry.later = true
		end
	end)
end

function M.registry()
	local copy = vim.deepcopy(registry)
	for _, entry in pairs(copy) do
		table.sort(entry.commands)
		table.sort(entry.events)
		table.sort(entry.loader_ids)
	end
	return copy
end

return M
