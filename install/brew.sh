#!/bin/sh
# Install homebrew packages

TAPS=(
    caskroom/cask
    caskroom/versions
)

FORMULAS=(
    autoconf
    automake
    ctags
    coreutils
    flake8
    fzf
    git
    go
    macvim
    pkg-config
    python
    python3
    reattach-to-user-namespace
    the_silver_searcher
    tig
    tree
    vim
    wget
    zsh
)

CASKS=(
    alfred
    dash
    dropbox
    google-chrome
    iterm2
    sourcetree
    spectacle
    sublime-text
)
# Others
#vagrant, virtualbox

for tap in ${TAPS[@]}
do
    brew tap $tap
done

brew install ${FORMULAS[@]}
brew update
brew cask install ${CASKS[@]}

# Installs that need flags
brew install tmux --HEAD
brew install emacs --with-cocoa
brew linkapps emacs

brew cleanup

