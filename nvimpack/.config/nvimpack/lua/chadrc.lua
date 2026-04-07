return {
	base46 = {
		theme = 'bearded-arc',
		transparency = true,
	},
	ui = {
		statusline = {
			enabled = true,
			theme = 'default',
			separator_style = 'default',
		},
    cmp = {
      icons_left = false, -- only for non-atom styles!
      style = "default", -- default/flat_light/flat_dark/atom/atom_colored
      abbr_maxwidth = 60,
      -- for tailwind, css lsp etc
      format_colors = { lsp = true, icon = "󱓻" },
    },
    telescope = { style = "borderless" }, -- borderless / bordered
		tabufline = {
			enabled = true,
			lazyload = true,
			order = { 'treeOffset', 'buffers', 'tabs', 'btns' },
			modules = nil,
			bufwidth = 21,
		},
		term = {
			base46_colors = true,
			winopts = { number = false, relativenumber = false },
			sizes = { sp = 0.3, vsp = 0.2, ['bo sp'] = 0.3, ['bo vsp'] = 0.2 },
			float = {
				relative = 'editor',
				row = 0.3,
				col = 0.25,
				width = 0.5,
				height = 0.4,
				border = 'single',
			},
		},
		colorify = {
			enabled = true,
			mode = 'virtual', -- fg, bg, virtual
			virt_text = '󱓻 ',
			highlight = { hex = true, lspvars = true },
		},
	},
	lsp = {
		signature = false,
	},
}
