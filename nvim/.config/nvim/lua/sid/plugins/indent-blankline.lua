return {
	'lukas-reineke/indent-blankline.nvim',
	event = 'BufReadPre',
	main = 'ibl',
	config = function()
		local highlight = {
			'RainbowRedDim',
			'RainbowYellowDim',
			'RainbowBlueDim',
			'RainbowOrangeDim',
			'RainbowGreenDim',
			'RainbowVioletDim',
			'RainbowCyanDim',
		}

		local hooks = require('ibl.hooks')
		-- create the highlight groups in the highlight setup hook, so they are reset
		-- every time the colorscheme changes
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			vim.api.nvim_set_hl(0, 'RainbowRedDim', { fg = '#b15e65' })
			vim.api.nvim_set_hl(0, 'RainbowYellowDim', { fg = '#b99e6b' })
			vim.api.nvim_set_hl(0, 'RainbowBlueDim', { fg = '#5b9bbe' })
			vim.api.nvim_set_hl(0, 'RainbowOrangeDim', { fg = '#bd8b5e' })
			vim.api.nvim_set_hl(0, 'RainbowGreenDim', { fg = '#8da269' })
			vim.api.nvim_set_hl(0, 'RainbowVioletDim', { fg = '#a467ba' })
			vim.api.nvim_set_hl(0, 'RainbowCyanDim', { fg = '#4c9aa2' })
		end)

		vim.g.rainbow_delimiters = { highlight = highlight }
		require('ibl').setup({ indent = { highlight = highlight } })
		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end,
}
