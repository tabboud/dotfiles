#!/usr/bin/env bash
# Install homebrew packages

TAPS=(
    caskroom/cask
    caskroom/versions
    neovim/neovim
)

FORMULAS=(
    autoconf
    automake
    coreutils
    ctags
    fd          # find replacement written in rust
    fzf
    git
    go
    neovim
    pkg-config
    reattach-to-user-namespace
    ripgrep     # search files
    sd          # search and displace
    stow
    the_silver_searcher
    tig
    tree
    vim
    wget
    zsh
    zsh-completions
)

CASKS=(
    1password
    alfred
    google-chrome
    hammerspoon
    iterm2
    itsycal         # Menubar calendar
    rectangle       # window snapping
    spotify
)

function brewAll() {
    for tap in ${TAPS[@]}
    do
        brew tap $tap
    done

    brew install ${FORMULAS[@]}
    brew update
    brew cask install ${CASKS[@]}

    # Installs that need flags
    brew install tmux --HEAD

    brew cleanup
}

function brewInstallStow() {
    brew install stow
}

function checkOrInstall() {
    # Check if Homebrew is installed or install it
    brew=$(which brew)
    if [ -z "$brew" ]; then
        echo "Installing homebrew..."
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "Homebrew already installed."
    fi
}


function usage() {
cat<<EOD
Usage:
    all -- brew install all casks and packages
    install-stow -- install stow only
EOD
  exit 1
}

if [[ "$#" == "0" ]]; then
  usage
fi

command="$1"
if [[ "$command" == "" ]]; then
  echo "first argument must be a command"
  usage
fi

checkOrInstall

case "$command" in
  all)
    brewAll
    ;;
  install-stow)
    brewInstallStow
    ;;
  *)
    usage
    ;;
esac

exit 0

