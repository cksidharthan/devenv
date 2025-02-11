return {
	'CopilotC-Nvim/CopilotChat.nvim',
	lazy = true,
	dependencies = {
		{ 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
		{ 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
	},
	build = 'make tiktoken', -- Only on MacOS or Linux
	opts = {},
	cmd = {
		'CopilotChat',
		'CopilotChatOpen',
		'CopilotChatClose',
		'CopilotChatToggle',
		'CopilotChatStop',
		'CopilotChatReset',
		'CopilotChatModels',
		'CopilotChatAgents',
		'CopilotChatExplain',
	},
	keys = {
		{ 'n', '<leader>cct', ':CopilotChat<CR>' },
	},
}
