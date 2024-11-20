return {
	'rmagatti/auto-session',
	lazy = true,
  keys = {
    "SessionDelete",
    "SessionRestore",
    "SessionSave",
    "SessionSearch",
    "SessionToggleAutoSave",
    "SessionDisableAutoSave",
    "SessionPurgeOrphaned"
  },

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
		-- log_level = 'debug',
	},
}
