local configured = false

vim.api.nvim_create_autocmd('InsertEnter', {
	once = true,
	callback = function()
		if configured then
			return
		end

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
