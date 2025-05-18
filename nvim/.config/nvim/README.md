# My Neovim Configuration

This is my personal Neovim configuration. It is a work in progress(indefinitely :P) and I am constantly tweaking it to make it better. I have tried to keep it as minimal as possible and only include the plugins that I find useful.

## Installation

_NOTE_:

- go to the file [README](/README.md) 
- If you have an existing Neovim configuration, make sure to backup your existing configuration before proceeding.
- This configuration is will work only on Neovim 0.10 and above.
- The leader key is set to `<Space>`. If you want to change it, you can do so by changing the value of `g:mapleader` in `./lua/sid/core/keymaps.lua`

1. Install [Neovim](https://neovim.io/)

2. Install dependencies:

   - Mac

   ```bash
   brew install lazygit ripgrep luarocks lazydocker gcc
   ```

   - Debian based systems

   ```bash
    sudo apt-get install lazygit ripgrep luarocks lazydocker gcc
   ```

3. Clone this repository to `~/.config/nvim` and open Neovim to install the plugins:

   ```bash
   git clone git@github.com:cksidharthan/nvim.git ~/.config/nvim && nvim
   ```

4. Install [Wezterm](https://wezfurlong.org/wezterm/installation.html) (optional)

## Features

- I use multiple plugins to enhance the functionality of Neovim. Some of the plugins that I use are:

  - Github Copilot
  - Telescope
  - Mason
  - Gitblame, Delve, etc.,
  - Lazy.nvim (for plugin lazy loading)
  - etc., (I tweak my configuration frequently and the list of plugins may change)

- I use [Wezterm](https://wezfurlong.org/wezterm/) as my terminal emulator. To know more on my wezterm configuration, check [here](https://github.com/cksidharthan/mac-setup/blob/main/.wezterm.lua)
