return {
	'nvim-telescope/telescope-frecency.nvim',
	-- install the latest stable version
	version = '*',
	config = function()
		require('telescope').load_extension('frecency')

    -- run :FrecencyDelete on startup
    -- vim.cmd('FrecencyDelete')

    require('telescope').setup({
      extensions = {
        frecency = {
          auto_validate = false,
          matcher = "fuzzy",
          ignore_patterns = { "*/.git", "*/.git/*", "*/.DS_Store", "*/vendor/*", "*/node_modules/*"},
          enable_prompt_mappings = true,
          -- db_safe_mode = true,
        }
      }
    })
	end,
}
