#!/usr/bin/env zsh

# Check if Golang is installed using brew, if yes continue with script, else install Golang
if brew list --formula | grep -q "go"; then
    echo "Golang is already installed. proceeding with installing Golang Command Line Tools"
else
    echo "Golang is not installed"
    echo "installing Golang"
    brew install go
fi

go_packages=(
    golang.org/x/tools/cmd/goimports
    github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen
    go.uber.org/mock/mockgen
    github.com/nikolaydubina/go-cover-treemap
    github.com/securego/gosec/v2/cmd/gosec
    github.com/go-delve/delve/cmd/dlv
    github.com/peterh/liner
    github.com/derailed/k9s
    github.com/jesseduffield/lazydocker
    github.com/jesseduffield/lazygit
    github.com/vmware/govmomi/govc
    github.com/sqlc-dev/sqlc/cmd/sqlc
    github.com/air-verse/air
)

# Install Golang packages
echo "Installing Golang packages..."
for package in "${go_packages[@]}"; do
    go install $package@latest
done
