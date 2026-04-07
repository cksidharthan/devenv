vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Exit terminal mode' })

local state = {
	buf = nil,
	win = nil,
}

local function open_window()
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
		state.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[state.buf].bufhidden = 'hide'
	end

	state.win = vim.api.nvim_open_win(state.buf, true, {
		relative = 'editor',
		width = width,
		height = height,
		col = col,
		row = row,
		style = 'minimal',
		border = 'rounded',
	})
end

local function toggle_terminal()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_hide(state.win)
		state.win = nil
		return
	end

	open_window()

	if vim.bo[state.buf].buftype ~= 'terminal' then
		vim.cmd('terminal')
	end

	vim.cmd('startinsert')
end

vim.api.nvim_create_user_command('FloatTerminal', toggle_terminal, {
	desc = 'Toggle floating terminal',
})

vim.keymap.set({ 'n', 't' }, '<leader>tt', '<cmd>FloatTerminal<cr>', {
	desc = 'Toggle floating terminal',
})
