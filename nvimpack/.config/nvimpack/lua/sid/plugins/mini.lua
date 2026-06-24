local pack = require('sid.pack')

-- mini.nvim covers icons, surround, and pairs in one place.
pack.startup({
	'https://github.com/nvim-mini/mini.nvim',
})

-- Provide icon helpers early because several other plugins look for web-devicons.
require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()

-- surround is useful everywhere, but not important enough to block startup.
vim.schedule(function()
	require('mini.surround').setup()
end)
