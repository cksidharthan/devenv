return {
	'shellRaining/hlchunk.nvim', -- indent-blankline.nvim alternative
	event = { 'BufReadPre', 'BufNewFile' },
	config = function()
		require('hlchunk').setup({
			chunk = {
				enable = true,
				chars = { right_arrow = '─', "│" },
				style = '#75A1FF',
				duration = 50,
				delay = 10,
			},
			indent = {
				enable = true,
				chars = { '┊' },
				style = {
					'#b15e65',
					'#b99e6b',
					'#5b9bbe',
					'#bd8b5e',
					'#8da269',
					'#a467ba',
					'#4c9aa2',
				},
			},
			line_num = { enable = false },
			exclude_filetypes = { 'help', 'git', 'markdown', 'snippets', 'text', 'gitconfig', 'alpha', 'dashboard' },
		})
	end,
}
