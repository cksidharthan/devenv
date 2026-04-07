-- Treesitter is loaded on first file open.
-- The job of this file is: make sure parsers exist, then start treesitter for current/future buffers.

local pack = require('sid.pack')

-- Keep the parser list explicit so this config stays predictable across machines.
local parsers = {
	'bash',
	'cmake',
	'css',
	'dockerfile',
	'gitignore',
	'go',
	'gomod',
	'gosum',
	'gowork',
	'html',
	'javascript',
	'json',
	'lua',
	'markdown',
	'markdown_inline',
	'proto',
	'python',
	'query',
	'regex',
	'scss',
	'toml',
	'tsx',
	'typescript',
	'vim',
	'vimdoc',
	'vue',
	'yaml',
}

local load_treesitter = pack.on_event({ 'BufReadPre', 'BufNewFile' }, 'treesitter', {
	'https://github.com/nvim-treesitter/nvim-treesitter',
	'https://github.com/windwp/nvim-ts-autotag',
}, function()
	-- Install any missing parsers (no-op for already-installed ones).
	local installed = require('nvim-treesitter.config').get_installed('parsers')
	local have = {}
	for _, name in ipairs(installed) do
		have[name] = true
	end
	local missing = {}
	for _, name in ipairs(parsers) do
		if not have[name] then
			table.insert(missing, name)
		end
	end
	if #missing > 0 then
		require('nvim-treesitter').install(missing)
	end

	-- Start treesitter highlighting + indent for any buffer that has a parser.
	vim.api.nvim_create_autocmd('FileType', {
		group = vim.api.nvim_create_augroup('sid-treesitter', { clear = true }),
		callback = function(args)
			if pcall(vim.treesitter.start, args.buf) then
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end,
	})

	-- The plugin is loaded on BufReadPre, so the FileType autocmd above won't
	-- fire for the buffer that triggered loading. Start it manually.
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= '' then
			if pcall(vim.treesitter.start, buf) then
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		end
	end

	require('nvim-ts-autotag').setup()
end)
