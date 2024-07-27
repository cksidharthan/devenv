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

# Wait for user to press any key
read -n 1 -s

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

## run the setup scripts
echo "Running setup/mac.sh"

## do a chmod +x on the scripts
chmod +x ./setup/mac.sh
chmod +x ./setup/brew.sh
chmod +x ./setup/go.sh
chmod +x ./setup/node.sh
chmod +x ./setup/config.sh

./setup/mac.sh
./setup/brew.sh
./setup/go.sh
./setup/node.sh
./setup/config.sh

source ~/.zshrc

echo "Setup complete. Please restart your terminal to see the changes"