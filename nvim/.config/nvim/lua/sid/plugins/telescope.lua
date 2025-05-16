return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	event = 'VeryLazy',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		'echasnovski/mini.icons',
	  'nvim-telescope/telescope-frecency.nvim',
	},
	config = function()
		local telescope = require('telescope')
		local actions = require('telescope.actions')

		telescope.setup({
			defaults = {
				prompt_prefix = ' 🚀 ',
				layout_strategy = 'horizontal',
				layout_config = {
					horizontal = {
						-- prompt_position = "top",
					},
				},
				path_display = { 'truncate' },
				mappings = {
					i = {
						['<C-k>'] = actions.move_selection_previous, -- move to previous result
						['<C-j>'] = actions.move_selection_next, -- move to next result
						['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
					},
				},
				file_ignore_patterns = { '.git/', 'node_modules/', 'vendor/', '.nuxt/', '.idea', '.vscode' },
			},
		})

		telescope.load_extension('fzf')

		vim.keymap.set('n', '<leader>fc', '<cmd>Telescope colorscheme<CR>', { desc = 'Change Colorscheme' })
		-- vim.keymap.set( 'n', '<leader>ff', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git', '-u' }})<CR>", { desc = 'Fuzzy find files in Current working directory' })
		vim.keymap.set( 'n', '<leader>ff', "<cmd>Telescope frecency workspace=CWD<CR>", { desc = 'Fuzzy find files in Current working directory' })
		vim.keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<CR>', { desc = 'Fuzzy find files in Recent files' })
		vim.keymap.set( 'n', '<leader>fs', '<cmd>Telescope live_grep<CR>', { desc = 'Fuzzy string in Current working directory' })
		-- add another keymap for listing open buffers
		vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Fuzzy find open buffers' })
		-- find todos
		vim.keymap.set( 'n', '<leader>en', '<cmd>Telescope frecency CWD=~/.config/nvim<CR>', { desc = 'Fuzzy find filetypes in Current working directory' })
		vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Fuzzy find help tags' })
		vim.keymap.set( 'n', '<leader>fib', '<cmd>Telescope current_buffer_fuzzy_find sorting_strategy=ascending<CR>', { desc = 'Fuzzy find in current buffer' })
		vim.keymap.set('n', '<leader>fk', '<cmd>Telescope keymaps<CR>', { desc = 'Fuzzy find keymaps' })
		vim.keymap.set('n', '<leader>fo', '<cmd>TodoTelescope<CR>', { desc = 'Fuzzy find TODOs' })
		-- add keymap for lsp symbols in the current buffer
		vim.keymap.set( 'n', '<leader>ft', '<cmd>Telescope lsp_document_symbols<CR>', { desc = 'Fuzzy find symbols and types in the current file' })
		vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, { desc = '[G]oto [D]efinition' })
		vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eferences' })
		vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations, { desc = '[G]oto [I]mplementation' })
		vim.keymap.set('n', '<leader>D', require('telescope.builtin').lsp_type_definitions, { desc = 'Type [D]efinition' })
		vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })
		vim.keymap.set( 'n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = '[W]orkspace [S]ymbols' })
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
		vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })
	end,
}
