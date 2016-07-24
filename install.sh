#!/bin/bash

echo "==> Installing dotfiles"

echo "Initializing submodule(s)..."
git submodule update --init --recursive

echo "Linking all dotfiles..."
source install/link.sh

if [ "$(uname)" == "Darwin" ]; then
    echo "Installing on OSX"

    echo "Checking if homebrew is installed..."
    brew=`which brew`
    if [ -z "$brew" ]
    then
        echo "Installing homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Homebrew already installed."
    fi

    echo "Brewing all the things..."
    source install/brew.sh

    echo "Updating OSX settings..."
    source installosx.sh

    echo "Linking sublime settings"
    source install/link_sublime.sh
elif [ "$(uname)" == "Linux" ]; then
    # assumes ubuntu
    sudo apt-get -y install zsh
fi

# Install oh-my-zsh
curl -L http://install.ohmyz.sh | sh

echo "<== Done"
