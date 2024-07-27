#!/usr/bin/env zsh

# Setup Finder Commands
# Show Library, Downloads, Desktop, Documents and home in Finder Sidebar favorites
chflags nohidden ~/Library
chflags nohidden ~/Downloads
chflags nohidden ~/Desktop
chflags nohidden ~/Documents
chflags nohidden ~

# Show Hidden Files in Finder
defaults write com.apple.finder AppleShowAllFiles YES

# Show Path Bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show Status Bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

echo "------------------------------"
echo "Installing Xcode Command Line Tools."
# Install Xcode command line tools
xcode-select --install

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the Pictures/Screenshots
mkdir -p ${HOME}/Pictures/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# Save screenshots to the Pictures/Screenshots
mkdir -p ${HOME}/Pictures/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
# defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Turn off Startup Sound
sudo nvram StartupMute=%01

# Turn on Key Repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# Make the Keyrepeat a bit fast not too fast
defaults write NSGlobalDomain KeyRepeat -int 3

# Key Repeat initial delay
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Set natural scrolling to off
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Set two finger tap to right click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true

# Remove Recents from Dock
defaults write com.apple.dock show-recents -bool false

# Set Dock to auto hide
defaults write com.apple.dock autohide -bool true

# Create dev folder where all projects will be cloned to
mkdir -p ${HOME}/dev
