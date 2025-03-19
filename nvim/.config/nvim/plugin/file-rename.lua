-- Function to rename the current file
local function rename_file()
	-- Get the current file path
	local current_file = vim.fn.expand('%')

	-- Check if we're in a real file buffer
	if current_file == '' or vim.bo.buftype ~= '' then
		vim.notify('Cannot rename: Not a file buffer', vim.log.levels.ERROR)
		return
	end

	-- Get the current file's directory and name
	local current_dir = vim.fn.expand('%:p:h')
	local current_name = vim.fn.expand('%:t')

	-- Prompt for new name with the current name as default
	local new_name = vim.fn.input('New name: ', current_name)

	-- If user cancelled or entered empty string, abort
	if new_name == '' or new_name == current_name then
		vim.notify('Rename cancelled', vim.log.levels.INFO)
		return
	end

	-- Construct the full new path
	local new_path = current_dir .. '/' .. new_name

	-- Attempt to rename the file
	local ok, err = os.rename(vim.fn.expand('%:p'), new_path)

	if not ok then
		vim.notify('Failed to rename file: ' .. (err or 'Unknown error'), vim.log.levels.ERROR)
		return
	end

	-- Update the buffer with the new file
	vim.cmd('saveas! ' .. vim.fn.fnameescape(new_path))
	-- Delete the old buffer
	vim.cmd('bd #')
	-- Remove the old file from the buffer list
	vim.cmd('bwipeout! #')

	vim.notify('File renamed to: ' .. new_name, vim.log.levels.INFO)
end

-- Set up the keymap
vim.keymap.set('n', '<leader>rf', rename_file, {
	noremap = true,
	silent = true,
	desc = 'Rename current file',
})

-- Return the module (optional, for requiring)
return {
	rename_file = rename_file,
}
