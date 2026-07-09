local pack = require('sid.pack')

local load_obsidian = pack.loader('obsidian', {
  {
    src = "https://github.com/obsidian-nvim/obsidian.nvim",
    version = vim.version.range "*", -- use latest release, remove to use latest commit
  },
}, function()
  -- obsidian.nvim detects the telescope picker by checking the runtimepath, so
  -- telescope.nvim must be added before setup() runs or it falls back to native.
  require('sid.plugins.telescope')()

  require("obsidian").setup {
    legacy_commands = false,   -- this will be removed in 4.0.0
    workspaces = {
      {
        name = "notes",
        path = os.getenv "NOTES_PATH" or "~/vaults/personal",
      },
    },
    picker = {
      name = "telescope.nvim", -- or telescope
    },
  }
end)

pack.command('Obsidian', load_obsidian, { nargs = '*', desc = 'Open obsidian' })

vim.keymap.set('n', '<leader>note', function()
  load_obsidian()
  vim.cmd('Obsidian')
end, { desc = 'Open obsidian' })
