if vim.g.vscode then
	-- vscode extension
	require('sid.core.settings')
	require('sid.core.keymaps')
	require('sid.core.autocommands')
	-- require('sid.lazy')
else
	require('sid.core.settings')
	require('sid.core.keymaps')
	require('sid.core.autocommands')
	require('sid.lazy')
end
