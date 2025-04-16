#!/usr/bin/env zsh

# Ask for the administrator password upfront.
echo "Please enter your password so we can install some packages."
sudo -v

# Generating ssh keys
echo "Generating ssh keys using Keygen"
# run ssh-keygen with default settings
ssh-keygen -t rsa -b 4096 -C "" -f ~/.ssh/id_rsa -q -N ""

## cat the public key to the terminal
cat ~/.ssh/id_rsa.pub

echo "Please add the above ssh key to your github account and press any key to continue"

# Ask for the administrator password upfront.
echo "Please enter your password so we can install some packages."
sudo -v

# Wait for user to press any key
read -s -n 1

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

## do a chmod +x on the scripts
chmod +x ./setup/mac.sh
chmod +x ./setup/brew.sh
chmod +x ./setup/go.sh
chmod +x ./setup/node.sh
chmod +x ./setup/configs.sh
chmod +x ./setup/stow.sh
chmod +x ./setup/pipx.sh

./setup/mac.sh
./setup/brew.sh

## refresh the shell
source ~/.zshrc
source ~/.zprofile

./setup/go.sh
./setup/node.sh
./setup/pipx.sh
./setup/configs.sh  # runs the stow commands
./setup/stow.sh

source ~/.zshrc

echo "Setup complete. Please restart your terminal to see the changes"
