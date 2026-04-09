-- chadrc is only for NvChad-provided UI pieces.
-- Keep editor behavior in lua/sid/* and use this file for theme/statusline/cmp UI knobs.

local function pack_dashboard_stats()
	local ok_plugins, plugins = pcall(vim.pack.get, nil, { info = false })
	if not ok_plugins then
		return '  vim.pack plugins unavailable'
	end

	local ok_registry, registry = pcall(function()
		return require('sid.pack').registry()
	end)

	local loaded = 0
	local stale = 0
	for _, plugin in ipairs(plugins) do
		if plugin.active then
			loaded = loaded + 1
		end
		if ok_registry and not registry[plugin.spec.name] then
			stale = stale + 1
		end
	end

	local configured = ok_registry and vim.tbl_count(registry) or #plugins
	local suffix = stale > 0 and ('  (%d stale)'):format(stale) or ''
	return ('  Loaded %d/%d configured plugins%s'):format(loaded, configured, suffix)
end

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
			order = { 'mode', 'file', 'git', '%=', 'lsp_msg', '%=', 'diagnostics', 'copilot', 'cwd', 'filetype', 'cursor' },
			modules = {
				filetype = function()
					local ft = vim.bo.filetype
					if ft == '' then
						return ''
					end

					local stl = require('nvchad.stl.utils')
					local sep_l = stl.separators['default'].left

					-- Get filetype icon from mini.icons
					local icon = '󰈙 ' -- fallback icon
					local ok, mini_icons = pcall(require, 'mini.icons')
					if ok then
						icon = mini_icons.get('filetype', ft)
					end

					return '%#St_pos_sep#' .. sep_l .. '%#St_pos_icon#' .. icon .. ' %#St_pos_text# ' .. ft .. ' '
				end,
				copilot = function()
					-- Multi-state copilot indicator: disabled / unknown / warning / enabled.
					-- copilot.lua loads on InsertEnter, so before that we render nothing.
					-- Icon is nf-md-github (U+F1928), present in every standard NerdFont build.
					local rok, cc = pcall(require, 'copilot.client')
					if not package.loaded['copilot'] or not rok then
						return ''
					end

					local icons = {
						enabled = ' ',
						sleep = ' ',
						disabled = ' ',
						warning = ' ',
						unknown = ' ',
					}

					local state
					if cc.is_disabled() then
						state = 'disabled'
					elseif not cc.id or not cc.buf_is_attached(vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)) then
						state = 'unknown'
					else
						local sok, status = pcall(require, 'copilot.status')
						local data_status = sok and status.data and status.data.status
						state = data_status == 'Warning' and 'warning' or 'enabled'
					end

					return '%#St_Copilot_' .. state .. '#' .. icons[state] .. ' '
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
		nvdash = {
			load_on_startup = true,
			header = {
				'                            ',
				'     ▄▄         ▄ ▄▄▄▄▄▄▄   ',
				'   ▄▀███▄     ▄██ █████▀    ',
				'   ██▄▀███▄   ███           ',
				'   ███  ▀███▄ ███           ',
				'   ███    ▀██ ███           ',
				'   ███      ▀ ███           ',
				'   ▀██ █████▄▀█▀▄██████▄    ',
				'     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ',
				'                            ',
				'     Powered By  eovim    ',
				'                            ',
			},

			buttons = {
				{ txt = '  Find File', keys = 'ff', cmd = 'Telescope find_files' },
				{ txt = '  Recent Files', keys = 'fo', cmd = 'Telescope oldfiles' },
				{ txt = '󰈭  Find Word', keys = 'fw', cmd = 'Telescope live_grep' },
				{ txt = '󰒲  Plugins', keys = 'pk', cmd = 'Pack' },
				{ txt = '󱥚  Themes', keys = 'th', cmd = 'NvChadThemes' },
				{ txt = '  Mappings', keys = 'ch', cmd = 'NvCheatsheet' },

				{ txt = '─', hl = 'NvDashFooter', no_gap = true, rep = true },

				{
					txt = pack_dashboard_stats,
					hl = 'NvDashFooter',
					no_gap = true,
				},

				{ txt = '─', hl = 'NvDashFooter', no_gap = true, rep = true },
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
