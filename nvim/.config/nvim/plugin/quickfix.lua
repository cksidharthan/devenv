-- This file customizes how quickfix/location lists are rendered.
-- It adds syntax-style highlighting, virtual filename headers, and smoother scrolling.

local namespace = vim.api.nvim_create_namespace('sid-quickfix')

local type_highlights = {
	E = 'DiagnosticSignError',
	W = 'DiagnosticSignWarn',
	I = 'DiagnosticSignInfo',
	N = 'DiagnosticSignHint',
	H = 'DiagnosticSignHint',
}

local function apply_highlights(bufnr, highlights)
	for _, item in ipairs(highlights) do
		-- Highlight exact text ranges after quickfix lines have been formatted.
		vim.hl.range(bufnr, namespace, item.group, { item.line, item.col }, { item.line, item.end_col })
	end
end

-- quickfixtextfunc must be global because the option references v:lua.
_G.quickfix_text = function(info)
	local list = info.quickfix == 1 and vim.fn.getqflist({ id = info.id, items = 1, qfbufnr = 1 })
		or vim.fn.getloclist(info.winid, { id = info.id, items = 1, qfbufnr = 1 })

	-- Build both the display text and the highlight instructions in one pass.
	local lines = {}
	local highlights = {}

	for index, item in ipairs(list.items) do
		local line_number = index - 1

		if item.bufnr == 0 then
			-- Plain list entries have no file location, so render them as simple text.
			local text = '  ' .. item.text
			table.insert(lines, text)
			table.insert(highlights, {
				group = 'qfText',
				line = line_number,
				col = 0,
				end_col = #text,
			})
		else
			-- File-backed entries are split into prefix, severity, line number, and message
			-- so each piece can be highlighted differently.
			local prefix = ' '
			local item_type = item.type and item.type ~= '' and (item.type .. ' ') or '  '
			local location = tostring(item.lnum) .. ': '
			local text = item.text:match('^%s*(.-)%s*$')
			local col = 0

			table.insert(lines, prefix .. item_type .. location .. text)
			table.insert(highlights, {
				group = 'qfText',
				line = line_number,
				col = col,
				end_col = col + #prefix,
			})
			col = col + #prefix

			table.insert(highlights, {
				group = type_highlights[item.type] or 'qfText',
				line = line_number,
				col = col,
				end_col = col + #item_type,
			})
			col = col + #item_type

			table.insert(highlights, {
				group = 'qfLineNr',
				line = line_number,
				col = col,
				end_col = col + #location,
			})
			col = col + #location

			table.insert(highlights, {
				group = 'qfText',
				line = line_number,
				col = col,
				end_col = col + #text,
			})
		end
	end

	vim.schedule(function()
		-- quickfixtextfunc is expected to return text immediately, so apply highlights later.
		apply_highlights(list.qfbufnr, highlights)
	end)

	return lines
end

vim.o.quickfixtextfunc = 'v:lua.quickfix_text'

local function add_virtual_filenames()
	if vim.bo[0].buftype ~= 'quickfix' then
		return
	end

	local list = vim.fn.getqflist({ id = 0, winid = 1, qfbufnr = 1, items = 1 })
	local last_filename = ''

	-- Clear stale filename headers before rebuilding them for the current list content.
	vim.api.nvim_buf_clear_namespace(list.qfbufnr, namespace, 0, -1)

	for index, item in ipairs(list.items) do
		local filename = vim.fn.fnamemodify(vim.fn.bufname(item.bufnr), ':p:.')

		if filename ~= '' and filename ~= last_filename then
			last_filename = filename
			-- Show the filename once above the first entry for that file to reduce repetition.
			vim.api.nvim_buf_set_extmark(list.qfbufnr, namespace, index - 1, 0, {
				virt_lines = { { { filename .. ':', 'qfFilename' } } },
				virt_lines_above = true,
				strict = false,
			})
		end
	end
end

vim.api.nvim_create_autocmd('BufReadPost', {
	desc = 'Show filenames above quickfix entries',
	callback = add_virtual_filenames,
})

local function scroll_above_first_line()
	if vim.bo[0].buftype ~= 'quickfix' then
		return
	end

	local row = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
	if row == 1 then
		-- Simulate half-page-up so you can reveal the virtual filename header above line 1.
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-u>', true, false, true), 'm', true)
	end
end

vim.api.nvim_create_autocmd('CursorMoved', {
	desc = 'Allow scrolling above the first quickfix line',
	callback = scroll_above_first_line,
})
