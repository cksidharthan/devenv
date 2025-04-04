local M = {}

function M.setup(capabilities, on_attach)
	-- TypeScript/JavaScript
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

	-- Tailwind CSS
	require('lspconfig').tailwindcss.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
	})

	-- HTML
	require('lspconfig').html.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { 'html' },
	})

	-- JSON
	require('lspconfig').jsonls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { 'json', 'jsonc' },
		settings = {
			json = {
				-- Use schemastore catalog for JSON schema completion
				schemas = require('schemastore').json.schemas(),
				validate = { enable = true },
			},
		},
	})

	--  local util = require 'lspconfig.util'
	--
	-- require('lspconfig').azure_pipelines_ls.setup({
	-- 	capabilities = capabilities,
	-- 	on_attach = on_attach,
	-- 	filetypes = { 'yaml', 'yaml.azure-pipelines' },
	--    cmd = { 'azure-pipelines-language-server', '--stdio' },
	--    root_dir = util.root_pattern 'azure-pipelines.yml',
	--    single_file_support = true,
	-- 	settings = {
	-- 		yaml = {
	-- 			schemas = {
	-- 				['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = {
	-- 					'azure/**/*.{yml,yaml}',
	-- 					'pipeline/**/*.{yml,yaml}',
	-- 					'pipelines/**/.*.{yml,yaml}',
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- })
end

return M
