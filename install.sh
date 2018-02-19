#!/usr/bin/env bash

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_NONE='\033[0m'
COLOR_YELLOW='\033[1;33m'

echo "Initializing submodule(s)..."
git submodule update --init --recursive


if [ "$(uname)" == "Darwin" ]; then
    echo "Installing stow..."
    bash install/brew.sh install-stow

    echo "Linking all dotfiles..."
    bash install/run_stow.sh osx

    echo "Brewing Everything..."
    bash install/brew.sh everything

    echo "Updating OSX settings..."
    bash install/osx.sh

    echo "Link in the iTerm font"
    source install/link_iterm_fonts.sh
elif [ "$(uname)" == "Linux" ]; then
    echo "Linking all dotfiles..."
    bash install/run_stow.sh linux
fi

echo -e "${COLOR_GREEN}✔ All Done!${COLOR_NONE}"

