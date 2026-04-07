local pack = require('sid.pack')

local function load_base46_cache()
	local cache_dir = vim.g.base46_cache
	local entries = vim.uv.fs_stat(cache_dir) and vim.fn.readdir(cache_dir) or {}

	if #entries == 0 then
		require('base46').load_all_highlights()
		return
	end

	local ok = true
	for _, name in ipairs(entries) do
		local path = cache_dir .. name
		local stat = vim.uv.fs_stat(path)
		if not stat or stat.size <= 64 or not pcall(dofile, path) then
			ok = false
			break
		end
	end

	if not ok then
		require('base46').load_all_highlights()
		return
	end

	vim.api.nvim_exec_autocmds('User', { pattern = 'NvThemeReload' })
end

pack.add({
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/NvChad/base46',
	'https://github.com/NvChad/ui',
})

load_base46_cache()
require('nvchad')
