#!/usr/bin/env zsh

## check if node is installed using brew, if yes continue with script, else install node
if brew list --formula | grep -q "node"; then
    echo "Node is already installed. proceeding with installing NPM Packages"
else
    echo "Node is not installed"
    echo "installing Node"
    brew install node
fi

# Install NPM Packages
npm install -g @redocly/cli@latest
npm install -g @quobix/vacuum
npm install -g newman jsonlint newman-reporter-htmlextra
npm install -g vscode-json-languageserver
npm install -g live-server
npm install -g @anthropic-ai/claude-code
