-- chadrc is only for NvChad-provided UI pieces.
-- Keep editor behavior in lua/sid/* and use this file for theme/statusline/cmp UI knobs.

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
			-- Default order plus our custom 'copilot' module just before 'cwd'.
			-- order = { 'mode', 'file', 'git', '%=', 'lsp_msg', '%=', 'diagnostics', 'lsp', 'copilot', 'cwd', 'cursor' },
			order = { 'mode', 'file', 'git', '%=', 'lsp_msg', '%=', 'diagnostics', 'copilot', 'cwd', 'cursor' },
			modules = {
				copilot = function()
					-- Multi-state copilot indicator. Mirrors copilot-lualine's branching:
					--   disabled  → globally disabled via :Copilot disable
					--   unknown   → loaded but not attached to this buffer
					--   warning   → copilot.status reports 'Warning'
					--   enabled   → attached and healthy
					-- copilot.lua loads on InsertEnter, so before that we render nothing.
					-- Icon is nf-md-github (U+F1928), which is present in every standard
					-- NerdFont build (the codicon-copilot glyph U+EBCB is not).
					if not package.loaded['copilot'] then
						return ''
					end

					local icons = {
						enabled = ' ',
						sleep = ' ',
						disabled = ' ',
						warning = ' ',
						unknown = ' ',
					}
					local function render(state)
						return '%#St_Copilot_' .. state .. '#' .. icons[state] .. ' '
					end

					local rok, cc = pcall(require, 'copilot.client')
					if not rok then
						return ''
					end
					if cc.is_disabled() then
						return render('disabled')
					end
					if not cc.id then
						return render('unknown')
					end

					local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
					if not cc.buf_is_attached(bufnr) then
						return render('unknown')
					end

					local sok, status = pcall(require, 'copilot.status')
					local data_status = sok and status.data and status.data.status or nil
					if data_status == 'Warning' then
						return render('warning')
					end

					return render('enabled')
				end,
			},
		},
		cmp = {
			icons_left = false, -- only for non-atom styles!
			style = 'default', -- default/flat_light/flat_dark/atom/atom_colored
			abbr_maxwidth = 60,
			-- Enable inline color chips for CSS/Tailwind style completion items.
			format_colors = { lsp = true, icon = '󱓻' },
		},
		telescope = { style = 'borderless' }, -- borderless / bordered
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
