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
    ctags
    coreutils
    flake8
    fzf
    git
    go
    httpie
    macvim
    mas         # mac-app-store cli
    neovim
    pkg-config
    python
    python3
    reattach-to-user-namespace
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
    alfred
    google-chrome
    firefox
    iterm2
    itsycal         # Menubar calendar
   sourcetree
    spectacle
    vanilla         # Hide menubar icons
)
# Others
#vagrant, virtualbox

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
    brew install emacs --with-cocoa
    brew linkapps emacs

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

