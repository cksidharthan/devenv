local pack = require('sid.pack')

-- mini.nvim covers icons, surround, and pairs in one place.
pack.add({
	'https://github.com/nvim-mini/mini.nvim',
})

require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()

vim.schedule(function()
	require('mini.surround').setup()
end)
