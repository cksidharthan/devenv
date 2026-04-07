-- UI startup is special because base46 can cache generated highlight files.
-- This file loads the theme plugins early, then restores or regenerates the cache.

local pack = require('sid.pack')

local function load_base46_cache()
	local cache_dir = vim.g.base46_cache
	local entries = vim.uv.fs_stat(cache_dir) and vim.fn.readdir(cache_dir) or {}

	if #entries == 0 then
		-- First run or cleared cache: generate all highlight files now.
		require('base46').load_all_highlights()
		return
	end

	local ok = true
	for _, name in ipairs(entries) do
		local path = cache_dir .. name
		local stat = vim.uv.fs_stat(path)
		-- base46 caches each highlight chunk as a Lua file; reject suspiciously small
		-- or invalid files and rebuild the cache from scratch.
		if not stat or stat.size <= 64 or not pcall(dofile, path) then
			ok = false
			break
		end
	end

	if not ok then
		require('base46').load_all_highlights()
		return
	end

	-- Tell the rest of the config that theme highlights are ready to be re-applied.
	vim.api.nvim_exec_autocmds('User', { pattern = 'NvThemeReload' })
end

-- These are startup-critical because other UI pieces assume the theme is available.
pack.add({
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/NvChad/base46',
	'https://github.com/NvChad/ui',
})

load_base46_cache()
require('nvchad')
