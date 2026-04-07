local vue_plugin_path = vim.fs.joinpath(
	vim.fn.stdpath('data'),
	'mason',
	'packages',
	'vue-language-server',
	'node_modules',
	'@vue',
	'language-server'
)

local plugins = {}
if vim.uv.fs_stat(vue_plugin_path) then
	plugins = {
		{
			name = '@vue/typescript-plugin',
			location = vue_plugin_path,
			languages = { 'vue' },
		},
	}
end

return {
	filetypes = {
		'javascript',
		'javascriptreact',
		'javascript.jsx',
		'typescript',
		'typescriptreact',
		'typescript.tsx',
		'vue',
	},
	init_options = {
		plugins = plugins,
	},
	root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
	single_file_support = true,
	settings = {
		javascript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = 'none',
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
			},
		},
		typescript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = 'none',
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
			},
		},
	},
}
