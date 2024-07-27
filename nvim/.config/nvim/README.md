# My Neovim Configuration

This is my personal Neovim configuration. It is a work in progress(indefinitely :P) and I am constantly tweaking it to make it better. I have tried to keep it as minimal as possible and only include the plugins that I find useful.

## Installation
*NOTE*: If you have an existing Neovim configuration, make sure to backup your existing configuration before proceeding.

1. Install [Neovim](https://neovim.io/)

2. Clone this repository to `~/.config/nvim`:
   ```bash
   git clone git@github.com:cksidharthan/nvim.git ~/.config/nvim
   ```

3. Install [Wezterm](https://wezfurlong.org/wezterm/installation.html) (optional)

4. Install dependencies:
   ```bash
   brew install lazygit ripgrep luarocks
   ```

## Features
- I use multiple plugins to enhance the functionality of Neovim. Some of the plugins that I use are:
  - Github Copilot
  - Telescope
  - Mason
  - Gitblame, Delve, etc., 
  - Lazy.nvim (for plugin lazy loading)
  - etc., (I tweak my configuration frequently and the list of plugins may change)

- I use [Wezterm](https://wezfurlong.org/wezterm/) as my terminal emulator. To know more on my wezterm configuration, check [here](https://github.com/cksidharthan/mac-setup/blob/main/.wezterm.lua)

## Keybindings

*NOTE*: I use `<Space>` as my leader key :)

There are two ways to view the keybindings:
1. type `<Space>` and wait for 2 seconds to view the keybindings
2. type `<Space>` and type `:Telescope keymaps` to view the keybindings

## Screenshots
![Screenshot 1](screenshots/screenshot1.png)
![Screenshot 2](screenshots/screenshot2.png)
![Screenshot 3](screenshots/screenshot3.png)

