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
brew tap cksidharthan/homebrew-tap

# Development tool casks
casks=(
    visual-studio-code
    firefox
    goland
    github
    docker
    brave-browser
    postman
    google-chrome
    appcleaner
    powershell
    rectangle
    wezterm
    font-jetbrains-mono-nerd-font
    font-martian-mono-nerd-font
    logi-options+
    bruno
    claude-code
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
    yq
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
    opa
    regal
    gnu-sed
    ripgrep
    bat
    go
    starship
    azure-cli
    fzf
    zoxide
    bun
    go-task
    lazygit
    stow
    helm-ls
    golang-migrate
    silicon
    styrainc/packages/regal
    lua-language-server
    yaml-language-server
    httpie
    golangci-lint
    mockery
    tree
    copilot-cli
    opencode
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
