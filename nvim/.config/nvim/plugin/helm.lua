-- Helm filetype detection, ported from towolf/vim-helm ftdetect/helm.vim

local function is_helm()
	local filepath = vim.fn.expand('%:p')

	-- yaml/yml/tpl/txt inside templates or sub dirs
	-- Chart.yaml exists in parent of templates dir
	local templates_pos = filepath:find('/templates/')
	if templates_pos then
		local chart_root = filepath:sub(1, templates_pos - 1)
		if vim.fn.filereadable(chart_root .. '/Chart.yaml') == 1 and filepath:match('%.ya?ml$') or filepath:match('%.tpl$') or filepath:match('%.txt$') then
			return true
		end
	end

	local filename = vim.fn.expand('%:t')

	-- helmfile templated values
	if filename:match('.*%.gotmpl$') then
		return true
	end

	-- helmfile.yaml / helmfile-my.yaml / helmfile_my.yaml etc
	if filename:match('^helmfile.*%.ya?ml$') then
		return true
	end

	return false
end

local group = vim.api.nvim_create_augroup('helm-ftdetect', { clear = true })

-- Wait until vim/neovim filetype detection is done
vim.api.nvim_create_autocmd('FileType', {
	group = group,
	pattern = { 'yaml', 'text', 'gotmpl' },
	callback = function()
		if is_helm() then
			vim.bo.filetype = 'helm'
		end
	end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
	group = group,
	pattern = '*.tpl',
	callback = function()
		if is_helm() then
			vim.bo.filetype = 'helm'
		end
	end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
	group = group,
	pattern = 'values*.yaml',
	callback = function()
		vim.bo.filetype = 'yaml.helm-values'
	end,
})

-- Use {{/* */}} as comments for helm files
vim.api.nvim_create_autocmd('FileType', {
	group = group,
	pattern = 'helm',
	callback = function()
		vim.bo.commentstring = '{{/* %s */}}'
	end,
})
