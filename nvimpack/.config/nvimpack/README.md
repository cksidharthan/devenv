# nvimpack

This is the `vim.pack` version of my Neovim config. It is intentionally smaller than the old `nvim` setup: the goal is to keep the core editing flow, keep the config readable, and avoid plugin overlap.

## What Changed

- Uses Neovim 0.12's built-in `vim.pack`.
- Keeps the core daily-use stack:
  - NvChad statusline via `NvChad/ui`
  - `nvim-tree`
  - `telescope`
  - built-in LSP configs through `nvim-lspconfig`
  - `blink.cmp`
  - `conform`
  - `gitsigns`
  - `flash`
  - `todo-comments`
  - `which-key`
  - `noice`
- Uses `mini.pairs` instead of `nvim-autopairs`.
- Removes `myeyeshurt`, `pathclip`, `garbage-day`, and `lualine`.
- Removes plugin duplication:
  - `oil.nvim` was dropped because `nvim-tree` is the file explorer here.
  - standalone `mini.icons` was dropped because `mini.nvim` already ships `mini.icons`.

## Layout

- `init.lua`: small entrypoint.
- `lua/sid/core`: options, keymaps, and autocmds.
- `lua/sid/pack.lua`: small helpers around `vim.pack.add()` and lazy-loading.
- `lua/sid/plugins`: one file per plugin or tightly related plugin family.
- `lsp`: custom overrides for servers that need extra settings.
- `after/ftplugin`: filetype-local indentation tweaks.
- `plugin`: small local helper plugins that do not need external dependencies.

## Lazy Loading

This config keeps lazy-loading simple on purpose:

- startup:
  - `mini.nvim`
  - `NvChad/base46`
  - `NvChad/ui`
- first file open:
  - treesitter
  - LSP
  - git signs
  - formatting
  - flash
  - todo-comments
- first insert:
  - `blink.cmp`
  - `mini.pairs`
- after startup:
  - `which-key`
  - `noice`
- on demand:
  - `nvim-tree`
  - `telescope`
  - `lazygit`

## First Run

Run Neovim with:

```bash
NVIM_APPNAME=nvimpack nvim
```

Useful pack commands:

```vim
:lua vim.pack.update()
:lua vim.pack.update(nil, { offline = true })
```

## Notes

- This config expects language servers and formatters to already be on your `PATH` or installed in `stdpath('data')/mason` where noted.
- If you want to remove old unused plugin directories from disk later, use `vim.pack.del()` after confirming the names from `vim.pack.get()`.
