local M = {}

-- Setup diagnostic signs
function M.setup_diagnostic_signs()
	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = ' ',
				[vim.diagnostic.severity.WARN] = ' ',
				[vim.diagnostic.severity.INFO] = '󰋼 ',
				[vim.diagnostic.severity.HINT] = '󰌵 ',
			},
			texthl = {
				[vim.diagnostic.severity.ERROR] = 'Error',
				[vim.diagnostic.severity.WARN] = 'Warn',
				[vim.diagnostic.severity.INFO] = 'Info',
				[vim.diagnostic.severity.HINT] = 'Hint',
			},
			numhl = {
				[vim.diagnostic.severity.ERROR] = '',
				[vim.diagnostic.severity.WARN] = '',
				[vim.diagnostic.severity.HINT] = '',
				[vim.diagnostic.severity.INFO] = '',
			},
		},
		virtual_text = true,
	})
end

-- Setup LSP capabilities
function M.get_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	return vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities(capabilities))
end

-- Setup document highlight
function M.setup_document_highlight(client, event)
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
end

-- Setup LSP attach
function M.setup_lsp_attach()
	-- Setup rename keybinding
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })

	-- Setup LSP attach event
	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
		callback = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)

			-- Setup keymaps
			local map = require('sid.lsp.keymaps').setup_keymaps(event)

			-- Setup document highlight
			M.setup_document_highlight(client, event)

			-- Setup inlay hints toggle
			if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
				map('<leader>th', function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end, '[T]oggle Inlay [H]ints')
			end
		end,
	})

	-- Setup LSP Zero
	local lsp_zero = require('lsp-zero')
	lsp_zero.on_attach(function(client, bufnr)
		lsp_zero.default_keymaps({ buffer = bufnr })
	end)
end

return M
