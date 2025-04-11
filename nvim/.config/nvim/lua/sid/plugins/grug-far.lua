return {
	'MagicDuck/grug-far.nvim',
  lazy = true,
  cmds = {
    "GrugFar",
    "GrugFarWithin",
  },
  keys = {
    { "<leader>gruf", "<cmd>GrugFar<cr>" },
    { "<leader>gruF", "<cmd>GrugFarWithin<cr>" },
  },
  opts = {},
	config = function()
		-- optional setup call to override plugin options
		-- alternatively you can set options with vim.g.grug_far = { ... }
		require('grug-far').setup({
			-- options, see Configuration section below
			-- there are no required options atm
			-- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
			-- be specified
      engine = "ripgrep"
		})
	end,
}
