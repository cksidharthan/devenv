return {
  cmd = {"ts_ls"},
  ft = {
			'javascript',
			'javascriptreact',
			'javascript.jsx',
			'typescript',
			'typescriptreact',
			'typescript.tsx',
			'vue',
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
}
