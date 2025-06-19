return {
	'ibhagwan/fzf-lua',
  enabled = false,
	dependencies = {
		'echannovski/mini.icons',
	},
	lazy = true,
	config = function()
		local fzf = require('fzf-lua')

		fzf.setup({
			-- General configuration
			global_resume = true,
			global_resume_query = true,
			fzf_opts = {
				-- Add fzf options
				['--layout'] = 'default',
				['--prompt'] = ' 🚀 ',
			},
			files = {
				prompt = ' 🚀 ',
				git_icons = true,
				file_icons = true,
				color_icons = true,
				cwd_prompt = false,
				find_opts = [[-type f -not -path "*/\.git/*" -not -path "*/node_modules/*" -not -path "*/vendor/*" -not -path "*/.nuxt/*" -not -path "*/.vscode/*" -not -path "*/venv/*" -not -path "*/.venv/*" -not -path "*/__pycache__/*"]],
				rg_opts = "--color=never --files --hidden --follow -g '!.git' -g '!node_modules' -g '!vendor' -g '!.nuxt' -g '!.vscode' -g '!venv' -g '!.venv' -g '!__pycache__'",
			},
			grep = {
				prompt = ' 🚀 ',
				git_icons = true,
				file_icons = true,
				color_icons = true,
				rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case -g '!.git' -g '!node_modules' -g '!vendor' -g '!.nuxt' -g '!.vscode' -g '!venv' -g '!.venv' -g '!__pycache__'",
			},
			buffers = {
				prompt = ' 🚀 ',
				file_icons = true,
				color_icons = true,
			},
			lsp = {
				prompt = ' 🚀 ',
				file_icons = true,
				color_icons = true,
			},
		})
	end,
	keys = {
		-- General file finding
		{ '<leader>fc', function() require('fzf-lua').colorschemes() end, desc = 'Change Colorscheme', },
		{ '<leader>ff', function() require('fzf-lua').files() end, desc = 'Fuzzy find files in Current working directory', },
		{ '<leader>fr', function() require('fzf-lua').oldfiles() end, desc = 'Fuzzy find files in Recent files', },
		{ '<leader>fs', function() require('fzf-lua').live_grep() end, desc = 'Fuzzy string in Current working directory', },
		{ '<leader>fn', function() require('fzf-lua').notify() end, desc = 'Fuzzy search in notifications', },
		{ '<leader>fb', function() require('fzf-lua').buffers() end, desc = 'Fuzzy find open buffers', },
		{ '<leader>en', function() require('fzf-lua').files({ cwd = '~/.config/nvim' }) end, desc = 'Fuzzy find filetypes in Current working directory', },
		{ '<leader>fh', function() require('fzf-lua').help_tags() end, desc = 'Fuzzy find help tags', },
		{ '<leader>fib', function() require('fzf-lua').blines() end, desc = 'Fuzzy find in current buffer', },
		{ '<leader>fk', function() require('fzf-lua').keymaps() end, desc = 'Fuzzy find keymaps', },
		{ '<leader>fo', function() require('fzf-lua').grep({ search = 'TODO|FIXME|NOTE|HACK|BUG' }) end, desc = 'Fuzzy find TODOs', },
		{ '<leader>ft', function() require('fzf-lua').lsp_document_symbols() end, desc = 'Fuzzy find symbols and types in the current file', },

		-- LSP related keymaps
		{ 'gd', function() require('fzf-lua').lsp_definitions() end, desc = '[G]oto [D]efinition', },
		{ 'gr', function() require('fzf-lua').lsp_references() end, desc = '[G]oto [R]eferences', },
		{ 'gi', function() require('fzf-lua').lsp_implementations() end, desc = '[G]oto [I]mplementation', },
		{ '<leader>D', function() require('fzf-lua').lsp_typedefs() end, desc = 'Type [D]efinition', },
		{ '<leader>ds', function() require('fzf-lua').lsp_document_symbols() end, desc = '[D]ocument [S]ymbols', },
		{ '<leader>ws', function() require('fzf-lua').lsp_workspace_symbols() end, desc = '[W]orkspace [S]ymbols', },

		-- The following keymaps are not directly fzf-lua related but kept for consistency
		{ '<leader>rn', vim.lsp.buf.rename, desc = '[R]e[n]ame' },
		{ '<leader>ca', vim.lsp.buf.code_action, mode = { 'n', 'x' }, desc = '[C]ode [A]ction' },
		{ 'gD', vim.lsp.buf.declaration, desc = '[G]oto [D]eclaration' },
	},
}
