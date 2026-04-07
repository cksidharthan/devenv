-- mini.pairs is part of mini.nvim, which is already loaded at startup.
-- This file delays only the setup call until the first insert session.

local configured = false

vim.api.nvim_create_autocmd('InsertEnter', {
	once = true,
	callback = function()
		if configured then
			return
		end

		-- Defer pair insertion behavior until the user actually starts typing.
		configured = true
		require('mini.pairs').setup()
	end,
})

return function()
	if configured then
		return
	end

	configured = true
	require('mini.pairs').setup()
end
