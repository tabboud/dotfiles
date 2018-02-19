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
    openbox
    tint2
)

function linkAll() {
    runStow "${COMMON[@]}"
    runStow "${OSX[@]}"
    runStow "${LINUX[@]}"
}

function linkOSX () {
    runStow "${OSX[@]}"
}

function linkLinux() {
    runStow "${LINUX[@]}"
}

function runStow() {
    arr=("$@")
    for package in "${arr[@]}"; do
        # stow -R $package
        stow -n $package
    done
}

function usage() {
cat<<EOD
Usage:
    linux -- link linux packages
    osx -- link osx packages
    all -- link all packages
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
    linkAll
    ;;
  osx)
    linkOSX
    ;;
  linux)
    linkLinux
    ;;
  *)
    usage
    ;;
esac

exit 0
