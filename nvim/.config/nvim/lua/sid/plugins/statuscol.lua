-- statuscol customizes the sign/fold/number column layout.

local pack = require('sid.pack')

local load_statuscol = pack.on_event({ 'BufReadPre', 'BufNewFile' }, 'statuscol', {
	'https://github.com/luukvbaal/statuscol.nvim',
}, function()
	local builtin = require('statuscol.builtin')
	require('statuscol').setup({
		setopt = true,
		-- Column order
		segments = {
			{ text = { '%s' }, click = 'v:lua.ScSa' }, -- signs column (like newly added but not commited to git, etc.,)
			{
				text = { builtin.lnumfunc, ' ' }, -- line number
				condition = { true, builtin.not_empty },
				click = 'v:lua.ScLa',
			},
			{ text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' }, ---- code folds
		},
	})
end)
