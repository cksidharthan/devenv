# Development Environment - DevEnv
My Local Development environment setup and management. It is a opinionated setup so YMMV :)

This setup has been tested only on macOS.

NOTE: I'm using gnu-stow for managing dotfiles and this configuration is setup with macOS in mind. I'm using zsh as my shell and oh-my-zsh as the zsh framework.
If the font is not rendering properly, please download and install nerd-fonts from [NerdFonts](https://www.nerdfonts.com/font-downloads)

Once you clone the repo run the run the `setup.sh` script in the root folder, that will setup up the whole environment with all the bells and whistles for you.

* Requied SECRETS in ~/.custom.sh
```bash
export ANTHROPIC_API_KEY="YOUR_API_KEY"  # required for avante chat in neovim
# add other secrets as needed
```
