return {
	'0x00-ketsu/autosave.nvim',
  event = 'BufReadPre',
	config = function()
		local autosave = require('autosave')
		autosave.setup({
			enable = true,
			prompt_style = 'notify',
			prompt_message = function()
				return 'Autosave: saved at ' .. vim.fn.strftime('%H:%M:%S')
			end,
			events = { 'FocusLost' },
			conditions = {
				exists = true,
				modifiable = true,
				filename_is_not = {},
				filetype_is_not = {},
			},
			write_all_buffers = true,
			debounce_delay = 2000,
		})
	end,
}
