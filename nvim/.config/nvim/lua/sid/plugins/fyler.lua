return {
	'A7Lavinraj/fyler.nvim',
	dependencies = { 'echasnovski/mini.icons' },
	branch = 'stable',
  keys = {
    { "<leader>ef", "<cmd>Fyler<cr>", desc = "Open Fyler" },
  },
	opts = {
		-- Allow user to confirm simple edits
		auto_confirm_simple_edits = false,

		-- NETRW Hijacking:
		-- The plugin will replace most of the netrw command
		-- By default this option is disable to avoid any incompatibility
		default_explorer = true,

		-- Close open file:
		-- This enable user to close fyler window on opening a file
		close_on_select = false,

		-- Defines icon provider used by fyler, integrated ones are below:
		-- - "mini-icons"
		-- - "nvim-web-devicons"
		-- It also accepts `fun(type, name): icon: string, highlight: string`
		icon_provider = 'mini-icons',

		-- Controls whether to show git status or not
		git_status = true,

		-- Controls behaviour of indentation marker
		indentscope = {
			enabled = true,
			group = 'FylerIndentMarker',
			marker = '│',
		},

		-- A function allow user to override highlight groups
		-- function definition:
		--[[
    function(hl_groups: table, palette: table)
      hl_groups.FylerIndentMarker = { fg = palette.white }
      ...
    end
  ]]
		--
		on_highlights = nil,

		-- Views configuration:
		-- Every view config contains following options to be customized
		-- `width` a number in (0, 1]
		-- `height` a number in (0, 1]

		-- `kind` could be as following:
		-- 'float',
		-- 'split:left',
		-- 'split:above',
		-- 'split:right',
		-- 'split:below'
		-- 'split:leftmost',
		-- 'split:abovemost',
		-- 'split:rightmost',
		-- 'split:belowmost'

		-- for `border` |:help winborder|
		views = {
			confirm = {
				width = 0.2,
				height = 0.2,
				kind = 'split:leftmost',
				border = 'single',
				buf_opts = {
					buflisted = false,
					modifiable = false,
				},
				win_opts = {
					winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,FloatTitle:FloatTitle',
					wrap = false,
				},
			},
			explorer = {
				width = 0.2,
				height = 0.2,
				kind = 'split:leftmost',
				border = 'single',
				buf_opts = {
					buflisted = false,
					buftype = 'acwrite',
					filetype = 'fyler',
					syntax = 'fyler',
				},
				win_opts = {
					concealcursor = 'nvic',
					conceallevel = 3,
					cursorline = true,
					number = true,
					relativenumber = true,
					winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,FloatTitle:FloatTitle',
					wrap = false,
				},
			},
		},

		-- Mappings:
		-- mappings can be customized by action names which are local to their view
		mappings = {
			confirm = {
				n = {
					['y'] = 'Confirm',
					['n'] = 'Discard',
				},
			},
			explorer = {
				n = {
					['q'] = 'CloseView',
					['<CR>'] = 'Select',
				},
			},
		},
	}, -- check the default options in the README.md
}
