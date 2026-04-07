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

-- Custom picker that lists active LSP clients with a structured preview.
-- pass { bufnr = 0 } to scope to clients attached to the current buffer.
local function lsp_clients_picker(opts)
	opts = opts or {}
	load_telescope()

	local pickers = require('telescope.pickers')
	local finders = require('telescope.finders')
	local conf = require('telescope.config').values
	local previewers = require('telescope.previewers')
	local actions = require('telescope.actions')

	local clients = vim.lsp.get_clients(opts.bufnr and { bufnr = 0 } or nil)
	if #clients == 0 then
		vim.notify('No active LSP clients', vim.log.levels.INFO)
		return
	end

	local function preview_lines(client)
		local lines = {}
		table.insert(lines, '▎ ' .. client.name .. '  (id: ' .. client.id .. ')')
		table.insert(lines, '')

		local root = client.root_dir
			or (client.config and client.config.root_dir)
			or '-'
		table.insert(lines, 'root:       ' .. root)

		local filetypes = (client.config and client.config.filetypes) or {}
		if #filetypes > 0 then
			table.insert(lines, 'filetypes:  ' .. table.concat(filetypes, ', '))
		end

		local cmd = client.config and client.config.cmd
		if type(cmd) == 'table' then
			table.insert(lines, 'cmd:        ' .. table.concat(cmd, ' '))
		elseif type(cmd) == 'string' then
			table.insert(lines, 'cmd:        ' .. cmd)
		end

		local bufs = vim.lsp.get_buffers({ client_id = client.id })
		if #bufs > 0 then
			local names = {}
			for _, b in ipairs(bufs) do
				local name = vim.api.nvim_buf_get_name(b)
				table.insert(names, name == '' and ('[buf ' .. b .. ']') or vim.fn.fnamemodify(name, ':~:.'))
			end
			table.insert(lines, 'buffers:    ' .. table.concat(names, ', '))
		end

		return lines
	end

	pickers
		.new(opts, {
			prompt_title = opts.bufnr and 'LSP Clients (current buffer)' or 'LSP Clients (active)',
			finder = finders.new_table({
				results = clients,
				entry_maker = function(client)
					local filetypes = (client.config and client.config.filetypes) or {}
					local display = string.format('%-20s [%s]', client.name, table.concat(filetypes, ','))
					return {
						value = client,
						display = display,
						ordinal = client.name,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = previewers.new_buffer_previewer({
				title = 'Client info',
				define_preview = function(self, entry)
					vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, preview_lines(entry.value))
				end,
			}),
			attach_mappings = function(prompt_bufnr)
				-- Selecting an entry just closes the picker — the preview is the payload.
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
				end)
				return true
			end,
		})
		:find()
end

pack.command('Telescope', load_telescope, { nargs = '*', desc = 'Open Telescope picker' })

vim.api.nvim_create_user_command('LspInfoTelescope', function(opts)
	lsp_clients_picker({ bufnr = opts.bang and 0 or nil })
end, {
	bang = true,
	desc = 'Telescope picker for LSP clients (use ! to scope to current buffer)',
})

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
vim.keymap.set('n', '<leader>fl', function()
	lsp_clients_picker({})
end, { desc = 'LSP clients (active)' })
vim.keymap.set('n', '<leader>ft', builtin('lsp_document_symbols'), { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>fn', function()
	-- noice owns the notification history, but telescope provides the searchable UI.
	load_telescope()
	vim.cmd('Noice telescope')
end, { desc = 'Search notifications' })

vim.keymap.set('n', 'gd', builtin('lsp_definitions'), { desc = 'Goto definition' })
vim.keymap.set('n', 'gr', builtin('lsp_references'), { desc = 'Goto references' })
vim.keymap.set('n', 'gi', builtin('lsp_implementations'), { desc = 'Goto implementation' })
vim.keymap.set('n', '<leader>D', builtin('lsp_type_definitions'), { desc = 'Type definition' })
vim.keymap.set('n', '<leader>ds', builtin('lsp_document_symbols'), { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>ws', builtin('lsp_dynamic_workspace_symbols'), { desc = 'Workspace symbols' })
