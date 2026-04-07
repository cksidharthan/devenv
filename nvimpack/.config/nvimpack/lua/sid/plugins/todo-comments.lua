local pack = require('sid.pack')

local load_todo_comments = pack.on_event({ 'BufReadPre', 'BufNewFile' }, 'todo-comments', {
	'https://github.com/folke/todo-comments.nvim',
}, function()
	local todo_comments = require('todo-comments')

	todo_comments.setup()

	vim.keymap.set('n', ']t', todo_comments.jump_next, { desc = 'Next TODO comment' })
	vim.keymap.set('n', '[t', todo_comments.jump_prev, { desc = 'Previous TODO comment' })
end)

vim.keymap.set('n', '<leader>fo', function()
	load_todo_comments()
	require('sid.plugins.telescope').load()
	vim.cmd('TodoTelescope')
end, { desc = 'Search TODOs' })

return {
	load = load_todo_comments,
}
