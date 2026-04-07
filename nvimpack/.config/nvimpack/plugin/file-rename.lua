local function rename_file()
	local old_path = vim.api.nvim_buf_get_name(0)

	if old_path == '' or vim.bo.buftype ~= '' then
		vim.notify('Cannot rename: current buffer is not a file', vim.log.levels.ERROR)
		return
	end

	if vim.bo.modified then
		vim.cmd('write')
	end

	local current_name = vim.fn.fnamemodify(old_path, ':t')
	local current_dir = vim.fn.fnamemodify(old_path, ':p:h')
	local new_name = vim.fn.input('New name: ', current_name)

	if new_name == '' or new_name == current_name then
		return
	end

	local new_path = current_dir .. '/' .. new_name
	local ok, err = os.rename(old_path, new_path)

	if not ok then
		vim.notify('Failed to rename file: ' .. (err or 'unknown error'), vim.log.levels.ERROR)
		return
	end

	vim.cmd('keepalt file ' .. vim.fn.fnameescape(new_path))
	vim.cmd('edit')
	vim.notify('Renamed to ' .. new_name, vim.log.levels.INFO)
end

vim.keymap.set('n', '<leader>rf', rename_file, {
	desc = 'Rename current file',
})

return {
	rename_file = rename_file,
}
