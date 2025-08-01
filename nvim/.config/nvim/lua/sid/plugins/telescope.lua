return {
  -- enabled = false,
	'nvim-telescope/telescope.nvim',
  lazy = true,
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		'echasnovski/mini.icons',
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
				file_ignore_patterns = { '.git/', 'node_modules/', 'vendor/', '.nuxt/', '.vscode', 'venv', '.venv', '__pycache__' },
			},
		})

		telescope.load_extension('fzf')
    telescope.load_extension("noice")
    telescope.load_extension('notify')
	end,
  keys = {
    -- File navigation
    { "<leader>fc", "<cmd>Telescope colorscheme<CR>", desc = 'Change Colorscheme' },
    { "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git', '-u' }})<CR>", desc = 'Fuzzy find files in Current working directory' },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = 'Fuzzy find files in Recent files' },
    { "<leader>fs", "<cmd>Telescope live_grep<CR>", desc = 'Fuzzy string in Current working directory' },
    { "<leader>fn", "<cmd>Telescope notify<CR>", desc = 'Fuzzy search in notifications' },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = 'Fuzzy find open buffers' },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = 'Fuzzy find help tags' },
    { "<leader>fib", "<cmd>Telescope current_buffer_fuzzy_find sorting_strategy=ascending<CR>", desc = 'Fuzzy find in current buffer' },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = 'Fuzzy find keymaps' },
    { "<leader>fo", "<cmd>TodoTelescope<CR>", desc = 'Fuzzy find TODOs' },
    { "<leader>ft", "<cmd>Telescope lsp_document_symbols<CR>", desc = 'Fuzzy find symbols and types in the current file' },
    
    -- LSP navigation with function references
    { "gd", function() require('telescope.builtin').lsp_definitions() end, desc = '[G]oto [D]efinition' },
    { "gr", function() require('telescope.builtin').lsp_references() end, desc = '[G]oto [R]eferences' },
    { "gi", function() require('telescope.builtin').lsp_implementations() end, desc = '[G]oto [I]mplementation' },
    { "<leader>D", function() require('telescope.builtin').lsp_type_definitions() end, desc = 'Type [D]efinition' },
    { "<leader>ds", function() require('telescope.builtin').lsp_document_symbols() end, desc = '[D]ocument [S]ymbols' },
    { "<leader>ws", function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, desc = '[W]orkspace [S]ymbols' },
    
    -- LSP actions
    { "<leader>rn", function() vim.lsp.buf.rename() end, desc = '[R]e[n]ame' },
    { "<leader>ca", function() vim.lsp.buf.code_action() end, mode = {"n", "x"}, desc = '[C]ode [A]ction' },
    { "gD", function() vim.lsp.buf.declaration() end, desc = '[G]oto [D]eclaration' },
  },
}
