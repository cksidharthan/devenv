-- Prevent loading this plugin multiple times
if vim.g.loaded_pathclip then
  return
end
vim.g.loaded_pathclip = 1

-- Function to get the absolute path of the current file
local function get_absolute_path()
  return vim.fn.expand('%:p')
end

-- Function to copy the path to the clipboard
local function copy_path_to_clipboard()
  local path = get_absolute_path()
  
  -- Check if the file exists (not a new unsaved buffer)
  if path == "" then
    vim.notify("No file open or file not saved yet", vim.log.levels.WARN)
    return
  end

  -- Copy to clipboard using both registers for compatibility
  vim.fn.setreg('+', path)
  vim.fn.setreg('*', path)
  
  -- Notify the user
  vim.notify("Copied to clipboard: " .. path, vim.log.levels.INFO)
end

-- Create a command to call the function
vim.api.nvim_create_user_command('CopyFilePath', function()
  copy_path_to_clipboard()
end, {})

-- Add default mapping directly in the plugin
vim.keymap.set('n', '<Leader>cp', ':CopyFilePath<CR>', { desc = "Copy file path to clipboard" })

-- Make functions available to other Lua code
_G.pathclip = {
  get_absolute_path = get_absolute_path,
  copy_path_to_clipboard = copy_path_to_clipboard
}
