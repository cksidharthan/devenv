-- lazygit is completely on demand.
-- Commands and the <leader>lg map all share the same loader.

local pack = require('sid.pack')

local load_lazygit = pack.loader('lazygit', {
	'https://github.com/kdheepak/lazygit.nvim',
})

for _, command in ipairs({
	'LazyGit',
	'LazyGitConfig',
	'LazyGitCurrentFile',
	'LazyGitFilter',
	'LazyGitFilterCurrentFile',
}) do
	pack.command(command, load_lazygit, { desc = command })
end

vim.keymap.set('n', '<leader>lg', function()
	load_lazygit()
	vim.cmd('LazyGit')
end, { desc = 'LazyGit' })
