return {
	'scottmckendry/cyberdream.nvim',
	lazy = false,
	priority = 1000,
	config = function()
		require('cyberdream').setup({
			-- Enable transparent background
			transparent = true,

			-- Enable italics comments
			italic_comments = true,

			-- Replace all fillchars with ' ' for the ultimate clean look
			hide_fillchars = true,

			-- Modern borderless telescope theme - also applies to fzf-lua
			borderless_telescope = true,

			-- Set terminal colors used in `:terminal`
			terminal_colors = false,

			-- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
			cache = true,

			theme = {
				variant = 'default', -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`

			},

			-- Disable or enable colorscheme extensions
			extensions = {
				telescope = true,
				notify = true,
				mini = true,
			},
		})
	end,
}
