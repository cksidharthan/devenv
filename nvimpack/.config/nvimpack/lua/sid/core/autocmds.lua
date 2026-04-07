local group = vim.api.nvim_create_augroup('sid-core-autocmds', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
	group = group,
	desc = 'Highlight yanked text',
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	group = group,
	pattern = 'json',
	callback = function(event)
		if vim.b[event.buf].format_json_command_created then
			return
		end

		vim.b[event.buf].format_json_command_created = true
		vim.api.nvim_buf_create_user_command(event.buf, 'FormatJSON', function(opts)
			vim.cmd(('%d,%d!jq \'.\''):format(opts.line1, opts.line2))
			vim.notify('JSON formatted with jq', vim.log.levels.INFO)
		end, {
			range = '%',
			desc = 'Format JSON with jq',
		})
	end,
})

local function set_filetype(patterns, filetype)
	vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
		group = group,
		pattern = patterns,
		callback = function(event)
			vim.bo[event.buf].filetype = filetype
		end,
	})
end

set_filetype({ 'docker-compose.yml', 'docker-compose.yaml' }, 'yaml.docker-compose')
set_filetype({ 'code.sid' }, 'sid')
set_filetype({ 'azure/pipelines/*.yml', 'azure/pipelines/*.yaml' }, 'yaml.azure-pipelines')

vim.api.nvim_create_autocmd('VimEnter', {
	group = group,
	callback = function()
		vim.lsp.log.set_level('off')
	end,
})

vim.api.nvim_create_user_command('LspLogOff', function()
	vim.lsp.log.set_level('off')
	print("LSP log level set to 'off'")
end, {})

vim.api.nvim_create_user_command('LspLogOn', function()
	vim.lsp.log.set_level('debug')
	print("LSP log level set to 'debug'")
end, {})
