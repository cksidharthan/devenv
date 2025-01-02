return {
	'neovim/nvim-lspconfig',
	event = 'BufReadPre',
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		'folke/lazydev.nvim',
		{ 'antosha417/nvim-lsp-file-operations', config = true },
		{ 'folke/neodev.nvim', opts = {} },
		{ 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
		'jose-elias-alvarez/typescript.nvim',
	},
	config = function()
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })

		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
			callback = function(event)
				-- NOTE: Remember that Lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself.
				--
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				local map = function(keys, func, desc, mode)
					mode = mode or 'n'
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
				end

				-- Jump to the definition of the word under your cursor.
				--  This is where a variable was first declared, or where a function is defined, etc.
				--  To jump back, press <C-t>.
				map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

				-- Find references for the word under your cursor.
				map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation.
				map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

				-- Fuzzy find all the symbols in your current workspace.
				--  Similar to document symbols, except searches over your entire project.
				map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
					vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd('LspDetach', {
						group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
						end,
					})
				end

				-- The following code creates a keymap to toggle inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map('<leader>th', function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, '[T]oggle Inlay [H]ints')
				end
			end,
		})

		-- import cmp-nvim-lsp plugin
		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
		for type, icon in pairs(signs) do
			local hl = 'DiagnosticSign' .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
		end

		local lsp_zero = require('lsp-zero')

		lsp_zero.on_attach(function(client, bufnr)
			-- see :help lsp-zero-keybindings
			-- to learn the available actions
			lsp_zero.default_keymaps({ buffer = bufnr })
		end)

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP Specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

		local on_attach = function(client)
			require('lsp-zero').on_attach(client)
		end

		require('lspconfig').tailwindcss.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
		})

		require('lspconfig').gopls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { 'go' },
			settings = {
				gopls = {
					codelenses = {
						gc_details = false,
						generate = true,
						regenerate_cgo = true,
						run_govulncheck = true,
						test = true,
						tidy = true,
						upgrade_dependency = true,
						vendor = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					analyses = {
						nilness = true,
						unusedparams = true,
						unusedwrite = true,
						useany = true,
					},
					-- usePlaceholders = true,
					completeUnimported = true,
					staticcheck = true,
					directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
					semanticTokens = true,
				},
			},
		})

		require('lspconfig').golangci_lint_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { 'go' },
		})

		require('lspconfig').ts_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			ft = {
				'javascript',
				'javascriptreact',
				'javascript.jsx',
				'typescript',
				'typescriptreact',
				'typescript.tsx',
			},
			settings = {
				completions = {
					completeFunctionCalls = true,
				},
			},
			init_options = {
				plugins = {
					{
						name = '@vue/typescript-plugin',
						location = vim.fn.expand('~/')
							.. '.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin',
						languages = { 'javascript', 'typescript', 'vue' },
					},
				},
			},
			filetypes = {
				'javascript',
				'typescript',
				'vue',
			},
		})

		require('lspconfig').lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { 'lua' },
		})

		require('lspconfig').pyright.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { 'python' },
		})

		require('lspconfig').volar.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { 'vue' },
			init_options = {
				typescript = {
					-- get the home directory of the current user and append the path to the typescript lib
					tsdk = vim.fn.expand('~/')
						.. '.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib',
				},
				preferences = {
					disableSuggestions = true,
				},
				languageFeatures = {
					implementation = true,
					references = true,
					definition = true,
					typeDefinition = true,
					callHierarchy = true,
					hover = true,
					rename = true,
					renameFileRefactoring = true,
					signatureHelp = true,
					codeAction = true,
					workspaceSymbol = true,
					diagnostics = true,
					semanticTokens = true,
					completion = {
						defaultTagNameCase = 'both',
						defaultAttrNameCase = 'kebabCase',
						getDocumentNameCasesRequest = false,
						getDocumentSelectionRequest = false,
					},
				},
			},
		})

		require('lspconfig').yamlls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { 'yaml', 'yaml.docker-compose' },
			settings = {
				yaml = {
					schemas = {
						kubernetes = 'k8s-*.yaml',
						['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
						['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
						['http://json.schemastore.org/chart'] = 'Chart.{yml,yaml}',
						['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = 'azure/*/*.{yml,yaml}',
						['https://taskfile.dev/schema.json'] = 'Taskfile.{yml,yaml}',
					},
					schemaStore = {
						enable = true,
					},
				},
			},
		})

		require('lspconfig').docker_compose_language_service.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			-- initialize on docker compose file
			filetypes = { 'yaml.docker-compose' },
			settings = {
				docker = {
					dockerComposeFile = {
						diagnostics = {
							enable = true,
							onStartup = true,
						},
						hover = {
							enable = true,
						},
						completion = {
							enable = true,
						},
					},
				},
			},
		})

		require('lspconfig').helm_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { 'helm' },
			settings = {
				yaml = {
					schemas = {
						kubernetes = '*.{yaml,yml}',
						['http://json.schemastore.org/chart'] = 'Chart.{yml,yaml}',
						['https://json.schemastore.org/chart.json'] = '/deployment/helm/*',
					},
				},
			},
		})

		require('lspconfig').dockerls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { 'dockerfile' },
		})

		require('lspconfig').html.setup({
			on_init = on_init,
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { 'html' },
		})

		require('lspconfig').sqls.setup({
			on_init = on_init,
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { 'sql', 'mysql' },
		})
	end,
}
