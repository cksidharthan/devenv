-- Global autocmds that are not tied to a single plugin live here.

local group = vim.api.nvim_create_augroup('sid-core-autocmds', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
	group = group,
	desc = 'Highlight yanked text',
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	group = group,
	pattern = 'json',
	callback = function(event)
		-- Create the command once per buffer so repeated filetype detection does not
		-- try to redefine it.
		if vim.b[event.buf].format_json_command_created then
			return
		end

		vim.b[event.buf].format_json_command_created = true
		vim.api.nvim_buf_create_user_command(event.buf, 'FormatJSON', function(opts)
			-- jq formats the selected range in-place; '%' means the whole buffer by default.
			vim.cmd(("%d,%d!jq '.'"):format(opts.line1, opts.line2))
			vim.notify('JSON formatted with jq', vim.log.levels.INFO)
		end, {
			range = '%',
			desc = 'Format JSON with jq',
		})
	end,
})

-- Small helper for filename patterns that Neovim does not detect the way we want.
local function set_filetype(patterns, filetype)
	vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
		group = group,
		pattern = patterns,
		callback = function(event)
			vim.bo[event.buf].filetype = filetype
		end,
	})
end

set_filetype({ 'docker-compose.yml', 'docker-compose.yaml' }, 'yaml.docker-compose')
set_filetype({ 'code.sid' }, 'sid')
set_filetype({ 'azure/pipelines/*.yml', 'azure/pipelines/*.yaml' }, 'yaml.azure-pipelines')

vim.api.nvim_create_autocmd('VimEnter', {
	group = group,
	callback = function()
		-- LSP debug logs are noisy; keep them off unless actively debugging a server.
		vim.lsp.log.set_level('off')
	end,
})

-- Highlight groups used by the chadrc statusline copilot module. Colors are
-- copied from copilot-lualine's defaults so the indicator reads the same way:
-- enabled (green), sleep (gray-blue), disabled (muted blue), warning (orange),
-- unknown (red). Re-applied on ColorScheme so base46 reloads cannot wipe them.
local copilot_colors = {
	enabled = '#50FA7B',
	sleep = '#AEB7D0',
	disabled = '#6272A4',
	warning = '#FFB86C',
	unknown = '#FF5555',
}
local function set_copilot_hl()
	for state, fg in pairs(copilot_colors) do
		vim.api.nvim_set_hl(0, 'St_Copilot_' .. state, { fg = fg, bg = 'NONE' })
	end
end
vim.api.nvim_create_autocmd('ColorScheme', { group = group, callback = set_copilot_hl })
set_copilot_hl()

-- Force a statusline redraw whenever copilot.lua's state changes so the chadrc
-- copilot module flips between hidden/visible without waiting for the next
-- cursor move. Two hooks, mirroring copilot-lualine's approach:
--   1. LspAttach for the 'copilot' client → triggers the first redraw and lets
--      us register the status notification handler exactly once.
--   2. status notification handler → keeps the bar in sync with later state
--      transitions (Normal/InProgress/Warning/Disabled).
local copilot_status_hooked = false
vim.api.nvim_create_autocmd('LspAttach', {
	group = group,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not (client and client.name == 'copilot') then
			return
		end
		vim.cmd.redrawstatus()
		if copilot_status_hooked then
			return
		end
		local ok, status = pcall(require, 'copilot.status')
		if ok and status.register_status_notification_handler then
			status.register_status_notification_handler(function()
				vim.cmd.redrawstatus()
			end)
			copilot_status_hooked = true
		end
	end,
})

-- Convenience commands for temporarily changing LSP log verbosity.
vim.api.nvim_create_user_command('LspLogOff', function()
	vim.lsp.log.set_level('off')
	print("LSP log level set to 'off'")
end, {})

vim.api.nvim_create_user_command('LspLogOn', function()
	vim.lsp.log.set_level('debug')
	print("LSP log level set to 'debug'")
end, {})
