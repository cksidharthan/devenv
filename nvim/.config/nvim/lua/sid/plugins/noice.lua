-- lazy.nvim
return {
	'folke/noice.nvim',
	event = 'VeryLazy',
	opts = {
		-- add any options here
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		'MunifTanjim/nui.nvim',
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		{
			'rcarriga/nvim-notify',
			opts = {
				render = 'compact',
				stages = 'slide',
				fps = 120,
			},
		},
	},
	config = function()
		require('noice').setup({
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
				},
				signature = {
					enabled = true,
					auto_show = true,
				},
				message = {
					enabled = false,
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},

      -- I added these routes as i was bombarded with Notify messages as "LSP Signature not available" which was annoying and was not needed for me.
			routes = {
				{
					filter = {
						event = 'notify',
						find = 'No signature help available',
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = 'lsp',
						find = 'signature help not available', -- Alternative message format
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = 'lsp',
						find = 'signature_help', -- Catch other signature help related messages
						kind = 'signature',
					},
					opts = { skip = true },
				},
			},
		})
	end,
}
