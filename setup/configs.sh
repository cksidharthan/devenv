#!/usr/bin/env zsh

# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# if ~/.zshrc exists, backup the file
if [ -f ~/.zshrc ]; then
    mv ~/.zshrc ~/.zshrc.bak
fi

# Set git config
git config --global user.name "Sidharthan Kamaraj"
git config --global user.email "csidharthank@gmail.com"
