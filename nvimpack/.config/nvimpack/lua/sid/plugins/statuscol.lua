local pack = require('sid.pack')

return pack.on_event({ 'BufReadPre', 'BufNewFile' }, 'statuscol', {
	'https://github.com/luukvbaal/statuscol.nvim',
}, function()
	local builtin = require('statuscol.builtin')
	require('statuscol').setup({
		setopt = true,
		-- number-less fold indicator, then signs, then line number & separator
		segments = {
			{ text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
			{ text = { '%s' }, click = 'v:lua.ScSa' },
			{
				text = { builtin.lnumfunc, ' ' },
				condition = { true, builtin.not_empty },
				click = 'v:lua.ScLa',
			},
		},
	})
end)
