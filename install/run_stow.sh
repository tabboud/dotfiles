#!/usr/bin/env bash
declare -a COMMON=(
    bin
    emacs
    git
    intellij
    tmux
    vim
    zsh
)
declare -a OSX=(
    hammerspoon
    iterm2
)
declare -a LINUX=(
    awesome
    openbox
    tint2
)

function all() {
    runStow $1 "${COMMON[@]}"
    runStow $1 "${OSX[@]}"
    runStow $1 "${LINUX[@]}"
}

function osx () {
    runStow $1 "${COMMON[@]}"
    runStow $1 "${OSX[@]}"
}

function linux() {
    runStow $1 "${COMMON[@]}"
    runStow $1 "${LINUX[@]}"
}

function runStow() {
    option=$1 && shift
    arr=("$@")
    for package in "${arr[@]}"; do
        if [ "$option" == "link" ]; then
            stow -R $package
        else
            stow -D $package
        fi
    done
}

function usage() {
cat<<EOD
Usage:
    linux [option] -- link linux packages
    osx   [option] -- link osx packages
    all   [option] -- link all packages

    option -> link (default) or unlink
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

# link (default) or unlink
option=${2:-"link"}

case "$command" in 
  all)
    all $option
    ;;
  osx)
    osx $option 
    ;;
  linux)
    linux $option
    ;;
  *)
    usage
    ;;
esac

exit 0
