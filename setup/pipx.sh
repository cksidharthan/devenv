#!/usr/bin/env zsh

# check if pipx is installed
if ! command -v pipx &> /dev/null
then
    echo "pipx is not installed. Installing pipx..."
    python3 -m pip install --user pipx
fi

# check if posting is installed
if ! command -v posting &> /dev/null
then
    echo "posting is not installed. Installing posting..."
    pipx install posting
fi
