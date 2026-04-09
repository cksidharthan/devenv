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
  - standalone `mini.icons` was dropped because `mini.nvim` already ships `mini.icons`.
- Keeps `oil.nvim` alongside `nvim-tree` (oil for buffer-style directory editing, nvim-tree as the sidebar).

## Layout

- `init.lua`: small entrypoint.
- `lua/sid/core`: options, keymaps, and autocmds.
- `lua/sid/pack.lua`: small helpers around `vim.pack.add()` and lazy-loading.
- `lua/sid/plugins`: one file per plugin or tightly related plugin family.
- `lsp`: custom overrides for servers that need extra settings.
- `after/ftplugin`: filetype-local indentation tweaks.
- `plugin`: small local helper plugins that do not need external dependencies.

## How To Read This Config

If you are new to the config, read it in this order:

1. `init.lua`
   - Shows the startup order at a glance.
   - Loads globals first, then core behavior, then the pack helpers, then plugins.
2. `lua/sid/core/*`
   - `options.lua` is the baseline editor behavior.
   - `autocmds.lua` is where one-off filetype behavior and helper commands live.
   - `keymaps.lua` is the shared keymap layer before plugin-specific mappings.
3. `lua/sid/pack.lua`
   - This is the main "how does lazy loading work here?" file.
   - Most plugin files use these helpers instead of calling `vim.pack.add()` directly.
4. `lua/sid/plugins/init.lua`
   - This is the plugin index.
   - It tells you which modules are expected to load at startup, on first file open, on insert, or on demand.
5. `lua/sid/plugins/*`
   - One file per plugin or feature area.
   - Read these when you want to understand Telescope, LSP, the file tree, and similar features.
6. `lsp/*`, `after/ftplugin/*`, and `plugin/*`
   - These are leaf files.
   - Read them last because they fine-tune behavior rather than defining the main structure.

In general, start with the files that explain structure and loading, then move to the files that only contain overrides.

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
  - `oil.nvim`
  - `telescope`
  - `lazygit`

## First Run

Run Neovim with:

```bash
NVIM_APPNAME=nvimpack nvim
```

Useful pack commands:

```vim
:Pack
:lua vim.pack.update()
:lua vim.pack.update(nil, { offline = true })
```

`:Pack` opens the local plugin dashboard for this config: loaded/idle/stale plugins, their lazy-load trigger, and quick actions for refresh, update, and stale-plugin cleanup.

## Notes

- This config expects language servers and formatters to already be on your `PATH` or installed in `stdpath('data')/mason` where noted.
- If you want to remove old unused plugin directories from disk later, use `vim.pack.del()` after confirming the names from `vim.pack.get()`.
