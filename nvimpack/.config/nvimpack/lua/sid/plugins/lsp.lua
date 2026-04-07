-- This file owns shared LSP behavior: diagnostics, common keymaps, and server enablement.
-- Per-server overrides live in ../lsp/*.lua.

local pack = require('sid.pack')

local function configure_lsp()
	-- lazydev improves Lua completion for Neovim config/plugin development.
	require('lazydev').setup({
		library = {
			{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
		},
	})

	-- Keep diagnostics informative without flooding the screen with virtual text.
	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = '󰅚 ',
				[vim.diagnostic.severity.WARN] = '󰀪 ',
				[vim.diagnostic.severity.INFO] = ' ',
				[vim.diagnostic.severity.HINT] = '󰌶 ',
			},
			numhl = {
				[vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
				[vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
				[vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
				[vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
			},
		},
		update_in_insert = false,
		virtual_text = false,
		virtual_lines = false,
	})

	-- Enable the servers that this config expects to have installed externally.
	local servers = {
		'docker_compose_language_service',
		'dockerls',
		'gopls',
		'golangci_lint_ls',
		'helm_ls',
		'html',
		'jsonls',
		'lua_ls',
		'pyright',
		'regal',
		'rust_analyzer',
		'sqls',
		'tailwindcss',
		'ts_ls',
		'vue_ls',
		'yamlls',
	}

	for _, server in ipairs(servers) do
		vim.lsp.enable(server)
	end

	-- Local custom language server used only when the binary exists on this machine.
	if vim.uv.fs_stat('/Users/sid/dev/cksidharthan/educationlsp/main') then
		vim.lsp.enable('educationlsp')
	end
end

-- These are set up eagerly because they are safe even before a server attaches.
vim.keymap.set('n', 'K', function()
	vim.lsp.buf.hover()
end, { desc = 'Hover documentation' })
vim.keymap.set('n', 'gD', function()
	vim.lsp.buf.declaration()
end, { desc = 'Goto declaration' })
vim.keymap.set({ 'n', 'x' }, '<leader>ca', function()
	vim.lsp.buf.code_action()
end, { desc = 'Code action' })
vim.keymap.set('n', '<leader>rn', function()
	vim.lsp.buf.rename()
end, { desc = 'Rename symbol' })
vim.keymap.set('n', '<leader>cd', function()
	vim.diagnostic.open_float()
end, { desc = 'Line diagnostics' })
vim.keymap.set('n', ']d', function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Previous diagnostic' })

-- :LspInfo and friends were removed from nvim-lspconfig when the native
-- vim.lsp.config API landed. These shims restore the muscle memory:
--   :LspInfo        -> clients attached to the current buffer
--   :LspInfoActive  -> all clients in the current Neovim session
--   :LspInfoAll     -> full :checkhealth vim.lsp report
--
-- LspInfo / LspInfoActive render into a floating window with one block per
-- client (name, id, root, filetypes, cmd, attached buffers) so the output is
-- skimmable instead of a raw vim.inspect dump.
local function format_client(client)
	local lines = {}
	table.insert(lines, string.format('▎ %s  (id: %d)', client.name, client.id))

	local root = client.root_dir
		or (client.config and client.config.root_dir)
		or '-'
	table.insert(lines, '   root:       ' .. root)

	local filetypes = (client.config and client.config.filetypes) or {}
	if #filetypes > 0 then
		table.insert(lines, '   filetypes:  ' .. table.concat(filetypes, ', '))
	end

	local cmd = client.config and client.config.cmd
	if type(cmd) == 'table' then
		table.insert(lines, '   cmd:        ' .. table.concat(cmd, ' '))
	elseif type(cmd) == 'string' then
		table.insert(lines, '   cmd:        ' .. cmd)
	end

	local bufs = vim.lsp.get_buffers_by_client_id(client.id)
	if #bufs > 0 then
		local names = {}
		for _, b in ipairs(bufs) do
			local name = vim.api.nvim_buf_get_name(b)
			table.insert(names, name == '' and ('[buf ' .. b .. ']') or vim.fn.fnamemodify(name, ':~:.'))
		end
		table.insert(lines, '   buffers:    ' .. table.concat(names, ', '))
	end

	return lines
end

local function show_lsp_info(title, clients)
	local lines = { title, string.rep('─', vim.fn.strdisplaywidth(title)), '' }
	if #clients == 0 then
		table.insert(lines, '  (no LSP clients)')
	else
		for i, client in ipairs(clients) do
			vim.list_extend(lines, format_client(client))
			if i < #clients then
				table.insert(lines, '')
			end
		end
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = 'wipe'
	vim.bo[buf].filetype = 'lspinfo'

	local width = 0
	for _, line in ipairs(lines) do
		local w = vim.fn.strdisplaywidth(line)
		if w > width then
			width = w
		end
	end
	width = math.min(width + 4, vim.o.columns - 4)
	local height = math.min(#lines, vim.o.lines - 4)

	vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = 'minimal',
		border = 'rounded',
		title = ' LSP Info ',
		title_pos = 'center',
	})

	vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, nowait = true, silent = true })
	vim.keymap.set('n', '<esc>', '<cmd>close<cr>', { buffer = buf, nowait = true, silent = true })
end

vim.api.nvim_create_user_command('LspInfo', function()
	show_lsp_info('LSP Clients (current buffer)', vim.lsp.get_clients({ bufnr = 0 }))
end, { desc = 'LSP clients attached to current buffer' })

vim.api.nvim_create_user_command('LspInfoActive', function()
	show_lsp_info('LSP Clients (all active)', vim.lsp.get_clients())
end, { desc = 'All active LSP clients in this session' })

vim.api.nvim_create_user_command('LspInfoAll', function()
	vim.cmd('checkhealth vim.lsp')
end, { desc = 'Full vim.lsp checkhealth report' })

local load_lsp = pack.on_event({ 'BufReadPre', 'BufNewFile' }, 'lsp', {
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/folke/lazydev.nvim',
	'https://github.com/b0o/SchemaStore.nvim',
}, configure_lsp)
