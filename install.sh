#!/bin/bash

echo "==> Installing dotfiles"

echo "Initializing submodule(s)..."
git submodule update --init --recursive

echo "Linking all dotfiles..."
source install/link.sh

if [ "$(uname)" == "Darwin" ]; then
    echo "Installing on OSX"

    echo "Brewing Everything..."
    source install/brew.sh

    echo "Updating OSX settings..."
    source install/osx.sh

    echo "Linking sublime settings"
    source install/link_sublime.sh
elif [ "$(uname)" == "Linux" ]; then
    # assumes ubuntu
    sudo apt-get -y install zsh
fi

# Install oh-my-zsh
#curl -L http://install.ohmyz.sh | sh

echo "<== Done"
