#!/usr/bin/env zsh

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Setup Homebrew
echo "Setting up Homebrew..."
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ${HOME}/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
brew analytics off
brew update
brew upgrade

## Taps and Casks
brew tap homebrew/cask
brew tap oven-sh/bun
brew tap homebrew/cask-fonts

# Development tool casks
casks=(
    visual-studio-code
    firefox
    goland
    github
    docker
    brave-browser
    arc
    postman
    google-chrome
    appcleaner
    powershell
    rectangle
    wezterm
    font-jetbrains-mono-nerd-font
    ticktick
    logi-options+
)

# Install casks
echo "Installing cask apps..."
for cask in "${casks[@]}"; do
    brew install --cask --appdir="/Applications" $cask
done

# Development tools
tools=(
    git
    docker-compose
    luarocks
    minikube
    jq
    make
    node
    npm
    wget
    neovim
    neofetch
    yamllint
    hadolint
    kubectl
    kubectx
    helm
    watch
    lazygit
    ca-certificates
    fd
    lua
    pipx
    luajit
    neovide
    opa
    regal
    gnu-sed
    ripgrep
    bat
    go
    starship
    azure-cli
    k6
    fzf
    zoxide
    bun
    go-task
    lazygit
    gnu-sed
    stow
    helm-ls
    tmux
    golang-migrate
    silicon
    styrainc/packages/eopa
    lua-language-server
    yaml-language-server
)

# Install tools
echo "Installing tools..."
for tool in "${tools[@]}"; do
    brew install $tool
done

# Remove outdated versions from the cellar.
# Some tidying up
echo "Running brew cleanup..."
brew autoremove -v
brew cleanup --prune=all
