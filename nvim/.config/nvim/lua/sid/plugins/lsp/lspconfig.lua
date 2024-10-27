return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"folke/lazydev.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
		"jose-elias-alvarez/typescript.nvim",
	},
	config = function()
		-- import cmp-nvim-lsp plugin
		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		local lsp_zero = require("lsp-zero")

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
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local on_init = function(client)
			client.resolved_capabilities.document_formatting = false
		end

		local on_attach = function(client)
			require("lsp-zero").on_attach(client)
		end

		require("lspconfig").tailwindcss.setup({
			capabilities = capabilities,
			on_attach = on_attach,
      filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
		})

		require("lspconfig").gopls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
      filetypes = { "go" },
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
					usePlaceholders = true,
					completeUnimported = true,
					staticcheck = true,
					directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
					semanticTokens = true,
				},
			},
		})

    require("lspconfig").golangci_lint_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "go" },
    })

		require("lspconfig").ts_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			ft = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			settings = {
				completions = {
					completeFunctionCalls = true,
				},
			},
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vim.fn.expand("~/")
							.. ".local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
						languages = { "javascript", "typescript", "vue" },
					},
				},
			},
			filetypes = {
				"javascript",
				"typescript",
				"vue",
			},
		})

		require("lspconfig").lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
      filetypes = { "lua" },
		})

		require("lspconfig").pyright.setup({
			capabilities = capabilities,
			on_attach = on_attach,
      filetypes = { "python" },
		})

		require("lspconfig").volar.setup({
			capabilities = capabilities,
			on_attach = on_attach,
      filetypes = { "vue" },
			init_options = {
				typescript = {
					-- get the home directory of the current user and append the path to the typescript lib
					tsdk = vim.fn.expand("~/")
						.. ".local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib",
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
						defaultTagNameCase = "both",
						defaultAttrNameCase = "kebabCase",
						getDocumentNameCasesRequest = false,
						getDocumentSelectionRequest = false,
					},
				},
			},
		})

		require("lspconfig").yamlls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "yaml", "yaml.docker-compose" },
			settings = {
				yaml = {
					schemas = {
						kubernetes = "k8s-*.yaml",
						["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
						["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
						["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
						["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = "azure/*/*.{yml,yaml}",
						["https://taskfile.dev/schema.json"] = "Taskfile.{yml,yaml}",
					},
          schemaStore = {
            enable = true
          }
				},
			},
		})

		require("lspconfig").docker_compose_language_service.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			-- initialize on docker compose file
			filetypes = { "yaml.docker-compose" },
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

		require("lspconfig").helm_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "helm" },
			settings = {
				yaml = {
					schemas = {
						kubernetes = "*.{yaml,yml}",
						["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
						["https://json.schemastore.org/chart.json"] = "/deployment/helm/*",
					},
				},
			},
		})

		require("lspconfig").dockerls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "dockerfile" },
		})

		require("lspconfig").html.setup({
			on_init = on_init,
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html" },
		})

    require("lspconfig").sqls.setup({
      on_init = on_init,
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "sql", "mysql" },
    })
	end,
}
