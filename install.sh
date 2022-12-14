#!/usr/bin/env bash

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_NONE='\033[0m'
COLOR_YELLOW='\033[1;33m'

OS="$(uname)"

# Ensure homebrew is installed.
function ensure_homebrew() {
    if test ! "$(command -v brew)"; then
        echo "Homebrew is not installed. Installing."
        # Run as a login shell (non-interactive) so that the script doesn't pause for user input
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
    fi
}

function bootstrap() {
    echo "Bootstrapping the system"
    if [ "$OS" == "Darwin" ]; then
        echo "Brewing Everything..."
        ensure_homebrew
        brew bundle

        echo "Updating OSX settings..."
        bash scripts/osx.sh
    fi
}

function dotfiles() {
    if [ "$OS" == "Darwin" ]; then
        if [ ! $(type -p stow) ]; then
            echo "stow is not installed. Installing."
            ensure_homebrew
            brew install stow
        fi

        echo "Linking osx dotfiles..."
        bash scripts/run_stow.sh osx
    elif [ "$OS" == "Linux" ]; then
        echo "Linking linux dotfiles..."
        bash scripts/run_stow.sh linux
    else
        echo "Unsupported OS type!"
        exit 1
    fi
}

function uninstall() {
    echo "Removing all dotfiles..."
    bash scripts/run_stow.sh all unlink
}

function usage() {
cat<<EOD
Usage:
    bootstrap   [options] -- Install software packages
    dotfiles    [options] -- Link all dotfiles
    all         [options] -- Install software and link dotfiles

    uninstall   [options] -- Remove all dotfile symlinks
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

case "$command" in
  all)
    bootstrap
    dotfiles
    ;;
  dotfiles)
    dotfiles
    ;;
  bootstrap)
    bootstrap
    ;;
  uninstall)
    uninstall
    ;;
  *)
    usage
    ;;
esac

echo -e "${COLOR_GREEN}✔ All Done!${COLOR_NONE}"
exit 0
