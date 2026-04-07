-- mini.pairs is part of mini.nvim, which is already loaded at startup.
-- This file delays only the setup call until the first insert session.

local configured = false

local function load_mini_pairs()
	if configured then
		return
	end

	configured = true
	require('mini.pairs').setup()
end

vim.api.nvim_create_autocmd('InsertEnter', {
	once = true,
	callback = function()
		-- Defer pair insertion behavior until the user actually starts typing.
		load_mini_pairs()
	end,
})
