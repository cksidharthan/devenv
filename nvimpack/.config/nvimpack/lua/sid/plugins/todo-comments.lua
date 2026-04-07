-- todo-comments loads when editing starts.
-- Telescope integration is wired separately so TODO search can force-load both pieces on demand.

local pack = require('sid.pack')

local load_todo_comments = pack.on_event({ 'BufReadPre', 'BufNewFile' }, 'todo-comments', {
	'https://github.com/folke/todo-comments.nvim',
}, function()
	local todo_comments = require('todo-comments')

	todo_comments.setup()

	-- These maps are defined after setup because they call plugin functions directly.
	vim.keymap.set('n', ']t', todo_comments.jump_next, { desc = 'Next TODO comment' })
	vim.keymap.set('n', '[t', todo_comments.jump_prev, { desc = 'Previous TODO comment' })
end)

vim.keymap.set('n', '<leader>fo', function()
	-- This path is demand-driven: load todo-comments, then telescope, then run the picker.
	load_todo_comments()
	require('sid.plugins.telescope').load()
	vim.cmd('TodoTelescope')
end, { desc = 'Search TODOs' })

return {
	load = load_todo_comments,
}
