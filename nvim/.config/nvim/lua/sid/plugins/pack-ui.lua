-- This file owns the :Pack UI end to end:
-- command registration, data collection, float layout, rendering, and actions.

local api = vim.api
local fn = vim.fn

local pack = require('sid.pack')

local M = {}
local NS = api.nvim_create_namespace('sid.pack.ui')

local SEPARATOR = ' │ '
local BLANK_ROW = { kind = 'blank', text = '' }
local HELP_TEXT = '  [hjkl]/arrows move   [r] refresh   [u] update   [x] delete stale   [<esc>] close'
local ACTION_KEYS = { '[u]', '[U]', '[r]', '[x]', '[X]', '[<esc>]' }

local FLOAT = {
	height_ratio = 0.82,
	min_height = 24,
	min_width = 90,
	width_ratio = 0.88,
}

local PANE = {
	left_ratio = 0.42,
	min_left = 38,
	min_right = 28,
	scrolloff = 2,
}

local STATUS_GROUPS = {
	{ icon = '󰄴', key = 'loaded', label = 'Loaded', hl = 'NvimPackLoaded' },
	{ icon = '󰐊', key = 'idle', label = 'Ready', hl = 'NvimPackIdle' },
	{ icon = '󰚌', key = 'stale', label = 'Stale', hl = 'NvimPackStale' },
}

local STATUS_ORDER = {
	loaded = 1,
	idle = 2,
	stale = 3,
}

local STATUS_BY_KEY = {}
for _, group in ipairs(STATUS_GROUPS) do
	STATUS_BY_KEY[group.key] = group
end

local state

local function reset_state()
	state = {
		augroup = nil,
		buf = nil,
		items = {},
		line_to_index = {},
		list_top = 1,
		rendering = false,
		selected_name = nil,
		win = nil,
	}
end

reset_state()

local function valid_buf()
	return state.buf ~= nil and api.nvim_buf_is_valid(state.buf)
end

local function valid_win()
	return state.win ~= nil and api.nvim_win_is_valid(state.win)
end

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO)
end

local function hl_value(name, key, fallback)
	local ok, highlight = pcall(api.nvim_get_hl, 0, { name = name, link = false })
	if ok and type(highlight) == 'table' and highlight[key] then
		return highlight[key]
	end
	return fallback
end

local function apply_highlights()
	-- Derive the palette from the active colorscheme so the Pack float stays in
	-- step with theme changes and NvChad/base46 reloads.
	local normal_bg = hl_value('Normal', 'bg', 0)
	local normal_fg = hl_value('Normal', 'fg', 0xffffff)
	local accent_fg = hl_value('Special', 'fg', normal_fg)
	local comment_fg = hl_value('Comment', 'fg', normal_fg)
	local border_fg = hl_value('FloatBorder', 'fg', hl_value('WinSeparator', 'fg', comment_fg))
	local cursor_bg = hl_value('CursorLine', 'bg', hl_value('Visual', 'bg', normal_bg))

	api.nvim_set_hl(0, 'NvimPackNormal', { bg = normal_bg, fg = normal_fg })
	api.nvim_set_hl(0, 'NvimPackTitle', { bold = true, fg = accent_fg })
	api.nvim_set_hl(0, 'NvimPackSection', { bold = true, fg = accent_fg })
	api.nvim_set_hl(0, 'NvimPackAccent', { bold = true, fg = hl_value('Function', 'fg', accent_fg) })
	api.nvim_set_hl(0, 'NvimPackMuted', { fg = comment_fg })
	api.nvim_set_hl(0, 'NvimPackLoaded', { bold = true, fg = hl_value('String', 'fg', accent_fg) })
	api.nvim_set_hl(0, 'NvimPackIdle', { bold = true, fg = hl_value('Function', 'fg', accent_fg) })
	api.nvim_set_hl(0, 'NvimPackStale', { bold = true, fg = hl_value('DiagnosticWarn', 'fg', accent_fg) })
	api.nvim_set_hl(0, 'NvimPackBorder', { fg = border_fg })
	api.nvim_set_hl(0, 'NvimPackCursorLine', { bg = cursor_bg })
end

local function shorten_path(path)
	return fn.fnamemodify(path, ':~')
end

local function shorten_sha(rev)
	if type(rev) ~= 'string' or rev == '' then
		return '-'
	end
	return rev:sub(1, 12)
end

local function version_text(version)
	return version == nil and 'default branch' or tostring(version)
end

local function preview_list(items, limit)
	if not items or #items == 0 then
		return '-'
	end

	local visible = vim.list_slice(items, 1, limit)
	local text = table.concat(visible, ', ')
	if #items > limit then
		text = text .. ('  (+%d more)'):format(#items - limit)
	end
	return text
end

local function trigger_text(meta)
	if not meta then
		return 'lockfile only'
	end

	local parts = {}
	if meta.startup then
		parts[#parts + 1] = 'startup'
	end
	if #meta.events > 0 then
		parts[#parts + 1] = 'event ' .. table.concat(meta.events, ', ')
	end
	if meta.later then
		parts[#parts + 1] = 'later'
	end
	if #meta.commands > 0 then
		local commands = vim.tbl_map(function(command)
			return ':' .. command
		end, meta.commands)
		parts[#parts + 1] = table.concat(commands, ', ')
	end

	return #parts == 0 and 'manual' or table.concat(parts, '  |  ')
end

local function plugin_status(plugin, meta)
	if plugin.active then
		return 'loaded'
	end
	return meta and 'idle' or 'stale'
end

local function collect_items()
	local registry = pack.registry()
	local items = {}

	for _, plugin in ipairs(vim.pack.get(nil, { info = true })) do
		local meta = registry[plugin.spec.name]
		items[#items + 1] = {
			branches = plugin.branches or {},
			meta = meta,
			name = plugin.spec.name,
			path = plugin.path,
			rev = plugin.rev,
			spec = plugin.spec,
			status = plugin_status(plugin, meta),
			tags = plugin.tags or {},
			trigger = trigger_text(meta),
		}
	end

	table.sort(items, function(left, right)
		local left_order = STATUS_ORDER[left.status] or math.huge
		local right_order = STATUS_ORDER[right.status] or math.huge
		if left_order ~= right_order then
			return left_order < right_order
		end
		return left.name < right.name
	end)

	return items
end

local function find_item(name)
	for index, item in ipairs(state.items) do
		if item.name == name then
			return item, index
		end
	end
end

local function selected_item()
	if state.selected_name then
		local item, index = find_item(state.selected_name)
		if item then
			return item, index
		end
	end
	return state.items[1], state.items[1] and 1 or nil
end

local function ensure_selection()
	local item = selected_item()
	if item then
		return
	end
	state.selected_name = state.items[1] and state.items[1].name or nil
end

local function status_summary()
	local counts = {
		loaded = 0,
		idle = 0,
		stale = 0,
	}

	for _, item in ipairs(state.items) do
		counts[item.status] = counts[item.status] + 1
	end

	return ('󰒲  %d plugins   󰄴 %d loaded   󰐊 %d ready   󰚌 %d stale'):format(
		#state.items,
		counts.loaded,
		counts.idle,
		counts.stale
	)
end

local function fit_display(text, width)
	if width <= 0 then
		return ''
	end

	local display_width = fn.strdisplaywidth(text)
	if display_width <= width then
		return text .. (' '):rep(width - display_width)
	end

	if width == 1 then
		return '…'
	end

	local parts = {}
	local used = 0
	local char_count = fn.strchars(text)
	for i = 0, char_count - 1 do
		local char = fn.strcharpart(text, i, 1)
		local char_width = fn.strdisplaywidth(char)
		if used + char_width + 1 > width then
			break
		end
		parts[#parts + 1] = char
		used = used + char_width
	end

	local clipped = table.concat(parts) .. '…'
	local clipped_width = fn.strdisplaywidth(clipped)
	if clipped_width < width then
		clipped = clipped .. (' '):rep(width - clipped_width)
	end

	return clipped
end

local function pane_widths(total_width)
	local separator_width = fn.strdisplaywidth(SEPARATOR)
	local left = math.max(PANE.min_left, math.floor(total_width * PANE.left_ratio))
	left = math.min(left, total_width - separator_width - PANE.min_right)
	local right = math.max(PANE.min_right, total_width - left - separator_width)
	return left, right
end

local function header_rows()
	return {
		{ kind = 'title', text = '󰒲  nvim.pack' },
		{ kind = 'subtitle', text = '   a local dashboard for vim.pack' },
		BLANK_ROW,
		{ kind = 'summary', text = status_summary() },
		{ kind = 'help', text = HELP_TEXT },
		BLANK_ROW,
	}
end

local function list_rows()
	local rows = {}
	local selected_row

	for _, group in ipairs(STATUS_GROUPS) do
		local group_size = 0
		for _, item in ipairs(state.items) do
			if item.status == group.key then
				group_size = group_size + 1
			end
		end

		if group_size > 0 then
			rows[#rows + 1] = {
				group = group,
				kind = 'group',
				text = ('%s  %s (%d)'):format(group.icon, group.label, group_size),
			}

			for item_index, item in ipairs(state.items) do
				if item.status == group.key then
					local selected = item.name == state.selected_name
					rows[#rows + 1] = {
						group = group,
						item = item,
						item_index = item_index,
						kind = 'plugin',
						selected = selected,
						text = string.format('%s %s %-24s %s', selected and '▎' or ' ', group.icon, item.name, item.trigger),
						trigger = item.trigger,
					}
					if selected then
						selected_row = #rows
					end
				end
			end

			rows[#rows + 1] = BLANK_ROW
		end
	end

	if #rows == 0 then
		rows[#rows + 1] = { kind = 'empty', text = '  No plugins managed by vim.pack' }
	end

	return rows, selected_row
end

local function field_row(label, value)
	return {
		kind = 'field',
		label = label,
		text = ('  %-10s %s'):format(label, value),
	}
end

local function detail_rows(item)
	if not item then
		return {
			{ kind = 'detail_title', hl = 'NvimPackTitle', text = '󰒲  nvim.pack' },
			BLANK_ROW,
			{ kind = 'hint', text = 'No plugin selected.' },
		}
	end

	local group = STATUS_BY_KEY[item.status]
	local meta = item.meta
	local rows = {
		{ kind = 'detail_title', hl = group.hl, text = ('%s  %s'):format(group.icon, item.name) },
		{ kind = 'detail_subtitle', text = ('%s  •  %s'):format(group.label:lower(), item.trigger) },
		BLANK_ROW,
		{ kind = 'section', text = 'Overview' },
		field_row('version', version_text(item.spec.version)),
		field_row('revision', shorten_sha(item.rev)),
		field_row('source', item.spec.src),
		field_row('path', shorten_path(item.path)),
		BLANK_ROW,
		{ kind = 'section', text = 'Load' },
		field_row('commands', meta and preview_list(meta.commands, 5) or '-'),
		field_row('events', meta and preview_list(meta.events, 5) or '-'),
		field_row('branches', preview_list(item.branches, 4)),
		field_row('tags', preview_list(item.tags, 4)),
		BLANK_ROW,
		{ kind = 'section', text = 'Actions' },
		{ kind = 'action', text = '  [u] update selected    [U] update all    [r] refresh' },
		{ kind = 'action', text = '  [x] delete stale       [X] clean stale   [<esc>] close' },
	}

	if item.status ~= 'stale' then
		rows[#rows + 1] = BLANK_ROW
		rows[#rows + 1] = {
			kind = 'hint',
			text = 'Configured plugins stay on disk. Remove them from the config first if you want them gone.',
		}
	end

	return rows
end

local function highlight_text(line_nr, text, needle, hl, offset)
	local start_col, end_col = text:find(needle, 1, true)
	if not start_col then
		return
	end

	api.nvim_buf_add_highlight(state.buf, NS, hl, line_nr - 1, offset + start_col - 1, offset + end_col)
end

local function highlight_left(line_nr, text, row)
	if row.kind == 'title' then
		api.nvim_buf_add_highlight(state.buf, NS, 'NvimPackTitle', line_nr - 1, 0, #text)
		return
	end
	if row.kind == 'subtitle' or row.kind == 'help' or row.kind == 'empty' then
		api.nvim_buf_add_highlight(state.buf, NS, 'NvimPackMuted', line_nr - 1, 0, #text)
		return
	end
	if row.kind == 'summary' then
		api.nvim_buf_add_highlight(state.buf, NS, 'NvimPackAccent', line_nr - 1, 0, #text)
		return
	end
	if row.kind == 'group' then
		api.nvim_buf_add_highlight(state.buf, NS, 'NvimPackSection', line_nr - 1, 0, #text)
		return
	end
	if row.kind ~= 'plugin' then
		return
	end

	local row_hl = row.group.hl
	highlight_text(line_nr, text, row.group.icon, row_hl, 0)
	highlight_text(line_nr, text, row.item.name, row_hl, 0)
	highlight_text(line_nr, text, row.trigger, 'NvimPackMuted', 0)
	if row.selected then
		highlight_text(line_nr, text, '▎', 'NvimPackAccent', 0)
	end
end

local function highlight_right(line_nr, text, row, offset)
	if row.kind == 'detail_title' then
		api.nvim_buf_add_highlight(state.buf, NS, row.hl or 'NvimPackTitle', line_nr - 1, offset, offset + #text)
		return
	end
	if row.kind == 'detail_subtitle' or row.kind == 'hint' then
		api.nvim_buf_add_highlight(state.buf, NS, 'NvimPackMuted', line_nr - 1, offset, offset + #text)
		return
	end
	if row.kind == 'section' then
		api.nvim_buf_add_highlight(state.buf, NS, 'NvimPackSection', line_nr - 1, offset, offset + #text)
		return
	end
	if row.kind == 'action' then
		api.nvim_buf_add_highlight(state.buf, NS, 'NvimPackMuted', line_nr - 1, offset, offset + #text)
		for _, key in ipairs(ACTION_KEYS) do
			highlight_text(line_nr, text, key, 'NvimPackAccent', offset)
		end
		return
	end
	if row.kind == 'field' then
		highlight_text(line_nr, text, row.label, 'NvimPackMuted', offset)
	end
end

local function write_lines(lines)
	state.rendering = true
	vim.bo[state.buf].modifiable = true
	api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
	vim.bo[state.buf].modifiable = false
	state.rendering = false
end

-- The float is a single buffer, so the left pane uses a virtual viewport:
-- all plugin rows exist conceptually, but only the visible slice is rendered.
local function visible_list_rows(rows, selected_row, list_height, header_count)
	local max_top = math.max(1, #rows - list_height + 1)
	local top = math.min(math.max(1, state.list_top), max_top)
	local scrolloff = math.min(PANE.scrolloff, math.max(0, math.floor(list_height / 4)))

	if selected_row then
		if selected_row < top + scrolloff then
			top = math.max(1, selected_row - scrolloff)
		elseif selected_row > top + list_height - 1 - scrolloff then
			top = math.min(max_top, selected_row - list_height + 1 + scrolloff)
		end
	end

	state.list_top = top

	local visible = {}
	local line_to_index = {}
	local cursor_line = header_count + 1

	for i = 1, list_height do
		local row = rows[top + i - 1] or BLANK_ROW
		visible[i] = row
		if row.kind == 'plugin' then
			local line_nr = header_count + i
			line_to_index[line_nr] = row.item_index
			if row.selected then
				cursor_line = line_nr
			end
		end
	end

	return visible, line_to_index, cursor_line
end

local function render()
	if not (valid_buf() and valid_win()) then
		return
	end

	-- Render is deliberately split into three steps:
	-- 1. collect rows for the left list and right details,
	-- 2. slice the left list into a viewport,
	-- 3. compose both panes into one scratch buffer.
	ensure_selection()

	local selected = selected_item()
	local width = api.nvim_win_get_width(state.win)
	local height = api.nvim_win_get_height(state.win)
	local left_width, right_width = pane_widths(width)
	local headers = header_rows()
	local rows, selected_row = list_rows()
	local visible, line_to_index, cursor_line =
		visible_list_rows(rows, selected_row, math.max(1, height - #headers), #headers)
	local left_rows = vim.deepcopy(headers)
	vim.list_extend(left_rows, visible)

	local details = detail_rows(selected)
	local detail_start = #headers + 1
	local total_lines = math.max(height, detail_start + #details - 1)
	local lines = {}
	local metadata = {}

	for line_nr = 1, total_lines do
		local left = left_rows[line_nr] or BLANK_ROW
		local right = detail_start <= line_nr and details[line_nr - detail_start + 1] or BLANK_ROW
		local left_text = fit_display(left.text, left_width)
		local right_text = fit_display(right.text, right_width)
		local separator_col = #left_text
		local right_offset = separator_col + #SEPARATOR

		lines[line_nr] = left_text .. SEPARATOR .. right_text
		metadata[line_nr] = {
			left = left,
			left_text = left_text,
			right = right,
			right_offset = right_offset,
			right_text = right_text,
			separator_col = separator_col,
		}
	end

	state.line_to_index = line_to_index
	write_lines(lines)

	api.nvim_buf_clear_namespace(state.buf, NS, 0, -1)
	for line_nr, row in ipairs(metadata) do
		api.nvim_buf_add_highlight(
			state.buf,
			NS,
			'NvimPackBorder',
			line_nr - 1,
			row.separator_col,
			row.separator_col + #SEPARATOR
		)
		highlight_left(line_nr, row.left_text, row.left)
		highlight_right(line_nr, row.right_text, row.right, row.right_offset)
	end

	pcall(api.nvim_win_set_cursor, state.win, { cursor_line, 0 })
end

local function float_config()
	local width = math.min(math.max(FLOAT.min_width, math.floor(vim.o.columns * FLOAT.width_ratio)), vim.o.columns - 4)
	local height = math.min(math.max(FLOAT.min_height, math.floor(vim.o.lines * FLOAT.height_ratio)), vim.o.lines - 4)
	return {
		border = 'rounded',
		col = math.max(0, math.floor((vim.o.columns - width) / 2)),
		height = math.max(10, height),
		relative = 'editor',
		row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
		style = 'minimal',
		title = ' 󰒲  Pack ',
		title_pos = 'center',
		width = math.max(60, width),
		zindex = 60,
	}
end

local function current_index()
	local _, index = selected_item()
	return index
end

local function move_selection(delta)
	local index = current_index()
	if not index then
		return
	end

	local next_index = math.max(1, math.min(#state.items, index + delta))
	state.selected_name = state.items[next_index].name
	render()
end

-- Mouse clicks or manual cursor movement should only change selection when the
-- cursor lands on a visible plugin row. Header and detail rows stay inert.
local function sync_selection_from_cursor()
	if state.rendering or not valid_win() then
		return
	end

	local line_nr = api.nvim_win_get_cursor(state.win)[1]
	local item_index = state.line_to_index[line_nr]
	if not item_index then
		return
	end

	local item = state.items[item_index]
	if item and item.name ~= state.selected_name then
		state.selected_name = item.name
		render()
	end
end

local function refresh()
	if not valid_win() then
		return
	end

	local ok, items = pcall(collect_items)
	if not ok then
		notify(('nvim.pack UI failed to refresh: %s'):format(items), vim.log.levels.ERROR)
		return
	end

	state.items = items
	if state.selected_name and not find_item(state.selected_name) then
		state.selected_name = nil
	end
	ensure_selection()
	render()
end

local function selected_stale_names()
	local names = {}
	for _, item in ipairs(state.items) do
		if item.status == 'stale' then
			names[#names + 1] = item.name
		end
	end
	return names
end

local function update_selected()
	local item = selected_item()
	if not item then
		return
	end

	local ok, err = pcall(vim.pack.update, { item.name })
	if not ok then
		notify(err, vim.log.levels.ERROR)
	end
end

local function update_all()
	local ok, err = pcall(vim.pack.update)
	if not ok then
		notify(err, vim.log.levels.ERROR)
	end
end

local function delete_selected()
	local item = selected_item()
	if not item then
		return
	end

	if item.status ~= 'stale' then
		notify(
			('`%s` is still configured. Remove it from the config before deleting it.'):format(item.name),
			vim.log.levels.WARN
		)
		return
	end

	local choice = fn.confirm(("Delete stale plugin '%s' from disk?"):format(item.name), '&Yes\n&No', 2, 'Warning')
	if choice ~= 1 then
		return
	end

	local ok, err = pcall(vim.pack.del, { item.name })
	if not ok then
		notify(err, vim.log.levels.ERROR)
		return
	end

	refresh()
end

local function clean_stale()
	local names = selected_stale_names()
	if #names == 0 then
		notify('No stale plugins to delete.', vim.log.levels.INFO)
		return
	end

	local choice = fn.confirm(('Delete %d stale plugin(s) from disk?'):format(#names), '&Yes\n&No', 2, 'Warning')
	if choice ~= 1 then
		return
	end

	local ok, err = pcall(vim.pack.del, names)
	if not ok then
		notify(err, vim.log.levels.ERROR)
		return
	end

	refresh()
end

local function close()
	if valid_win() then
		pcall(api.nvim_win_close, state.win, true)
	end
	if valid_buf() then
		pcall(api.nvim_buf_delete, state.buf, { force = true })
	end
	if state.augroup then
		pcall(api.nvim_del_augroup_by_id, state.augroup)
	end
	reset_state()
end

local function map(lhs, rhs, desc)
	vim.keymap.set('n', lhs, rhs, {
		buffer = state.buf,
		desc = desc,
		nowait = true,
		silent = true,
	})
end

local function setup_buffer()
	vim.bo[state.buf].buftype = 'nofile'
	vim.bo[state.buf].bufhidden = 'wipe'
	vim.bo[state.buf].filetype = 'nvimpack'
	vim.bo[state.buf].modifiable = false
	vim.bo[state.buf].swapfile = false
end

local function setup_window()
	local opts = {
		cursorline = true,
		foldcolumn = '0',
		number = false,
		relativenumber = false,
		signcolumn = 'no',
		spell = false,
		wrap = false,
		winblend = 0,
		winhighlight = 'Normal:NvimPackNormal,CursorLine:NvimPackCursorLine,EndOfBuffer:NvimPackNormal,FloatBorder:NvimPackBorder',
	}

	for key, value in pairs(opts) do
		api.nvim_set_option_value(key, value, { win = state.win })
	end
end

local function setup_keymaps()
	map('q', close, 'Close nvim.pack UI')
	map('<esc>', close, 'Close nvim.pack UI')
	map('j', function()
		move_selection(1)
	end, 'Next plugin')
	map('k', function()
		move_selection(-1)
	end, 'Previous plugin')
	map('l', function()
		move_selection(1)
	end, 'Next plugin')
	map('h', function()
		move_selection(-1)
	end, 'Previous plugin')
	map('<Down>', function()
		move_selection(1)
	end, 'Next plugin')
	map('<Up>', function()
		move_selection(-1)
	end, 'Previous plugin')
	map('<Right>', function()
		move_selection(1)
	end, 'Next plugin')
	map('<Left>', function()
		move_selection(-1)
	end, 'Previous plugin')
	map('r', refresh, 'Refresh plugin data')
	map('u', update_selected, 'Update selected plugin')
	map('U', update_all, 'Update all plugins')
	map('x', delete_selected, 'Delete selected stale plugin')
	map('X', clean_stale, 'Delete all stale plugins')
end

local function setup_autocmds()
	state.augroup = api.nvim_create_augroup('SidPackUi', { clear = true })

	api.nvim_create_autocmd('CursorMoved', {
		buffer = state.buf,
		callback = sync_selection_from_cursor,
		group = state.augroup,
	})

	api.nvim_create_autocmd('PackChanged', {
		callback = function()
			vim.schedule(refresh)
		end,
		group = state.augroup,
	})

	api.nvim_create_autocmd({ 'ColorScheme', 'User' }, {
		callback = function(event)
			if event.event == 'User' and event.match ~= 'NvThemeReload' then
				return
			end
			apply_highlights()
			if valid_win() then
				vim.schedule(render)
			end
		end,
		group = state.augroup,
	})

	api.nvim_create_autocmd('VimResized', {
		callback = function()
			if valid_win() then
				api.nvim_win_set_config(state.win, float_config())
				vim.schedule(render)
			end
		end,
		group = state.augroup,
	})

	api.nvim_create_autocmd('WinClosed', {
		callback = function(event)
			if tonumber(event.match) == state.win then
				close()
			end
		end,
		group = state.augroup,
	})
end

local function open_float()
	state.buf = api.nvim_create_buf(false, true)
	state.win = api.nvim_open_win(state.buf, true, float_config())
	setup_buffer()
	apply_highlights()
	setup_window()
	setup_keymaps()
	setup_autocmds()
end

function M.open()
	if valid_win() then
		api.nvim_set_current_win(state.win)
		refresh()
		return
	end

	close()
	open_float()
	refresh()
end

function M.refresh()
	refresh()
end

vim.api.nvim_create_user_command('Pack', function()
	M.open()
end, { nargs = 0, desc = 'Open the nvim.pack UI' })

return M
