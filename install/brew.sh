#!/bin/sh
# Install homebrew packages

TAPS=(
    caskroom/cask
)

FORMULAS=(
    autoconf
    automake
    caskroom/cask/brew-cask
    ctags
    coreutils
    git
    go
    macvim
    pkg-config
    python
    python3
    the_silver_searcher
    tig
    tree
    vim
    wget
    zsh
)

CASKS=(
    iterm2
    dropbox
    firefox
    google-chrome
    sourcetree
    sublime-text3
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

exit 0
