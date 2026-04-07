-- Telescope is loaded on demand because it is mostly picker-driven.
-- Read this file as: helper functions first, setup second, then keymaps.

local pack = require('sid.pack')

local function find_all_files()
	-- Fall back to ripgrep directly so hidden files are included and common large
	-- directories are excluded even outside a git repo.
	require('telescope.builtin').find_files({
		find_command = {
			'rg',
			'--files',
			'--hidden',
			'-g',
			'!.git',
			'-g',
			'!vendor',
			'-g',
			'!node_modules',
			'-u',
		},
	})
end

local load_telescope = pack.loader('telescope', {
	'https://github.com/nvim-telescope/telescope.nvim',
	{ src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },
}, function()
	local telescope = require('telescope')
	local actions = require('telescope.actions')

	telescope.setup({
		defaults = {
			prompt_prefix = ' 🚀 ',
			layout_strategy = 'horizontal',
			path_display = { 'truncate' },
			mappings = {
				i = {
					['<C-k>'] = actions.move_selection_previous,
					['<C-j>'] = actions.move_selection_next,
					['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
				},
			},
			file_ignore_patterns = {
				'^./.git/',
				'^*/node_modules/',
				'^vendor/',
				'^.nuxt/',
				'^.vscode/',
				'^venv/',
				'^.venv/',
				'^__pycache__/',
				'^.idea/',
			},
		},
	})

	pcall(telescope.load_extension, 'fzf')
	pcall(telescope.load_extension, 'noice')
end)

local function builtin(name, opts)
	return function()
		-- Small wrapper so every picker map can be lazy-loaded the same way.
		load_telescope()
		require('telescope.builtin')[name](opts)
	end
end

vim.keymap.set('n', '<leader>fc', builtin('colorscheme'), { desc = 'Change colorscheme' })
vim.keymap.set('n', '<leader>ff', function()
	load_telescope()
	find_all_files()
end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', function()
	load_telescope()
	local builtin_mod = require('telescope.builtin')
	-- Prefer git_files inside repos because it is faster and follows gitignore.
	local ok = pcall(builtin_mod.git_files)
	if not ok then
		find_all_files()
	end
end, { desc = 'Find git files' })
vim.keymap.set('n', '<leader>fr', builtin('oldfiles'), { desc = 'Recent files' })
vim.keymap.set('n', '<leader>fs', builtin('live_grep'), { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin('buffers'), { desc = 'Open buffers' })
vim.keymap.set('n', '<leader>fh', builtin('help_tags'), { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fib', function()
	load_telescope()
	require('telescope.builtin').current_buffer_fuzzy_find({
		sorting_strategy = 'ascending',
	})
end, { desc = 'Search current buffer' })
vim.keymap.set('n', '<leader>fk', builtin('keymaps'), { desc = 'Search keymaps' })
vim.keymap.set('n', '<leader>ft', builtin('lsp_document_symbols'), { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>fn', function()
	-- noice owns the notification history, but telescope provides the searchable UI.
	require('sid.plugins.noice').load()
	load_telescope()
	pcall(function()
		require('telescope').load_extension('noice')
	end)
	vim.cmd('Noice telescope')
end, { desc = 'Search notifications' })

vim.keymap.set('n', 'gd', builtin('lsp_definitions'), { desc = 'Goto definition' })
vim.keymap.set('n', 'gr', builtin('lsp_references'), { desc = 'Goto references' })
vim.keymap.set('n', 'gi', builtin('lsp_implementations'), { desc = 'Goto implementation' })
vim.keymap.set('n', '<leader>D', builtin('lsp_type_definitions'), { desc = 'Type definition' })
vim.keymap.set('n', '<leader>ds', builtin('lsp_document_symbols'), { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>ws', builtin('lsp_dynamic_workspace_symbols'), { desc = 'Workspace symbols' })

return {
	load = load_telescope,
}
