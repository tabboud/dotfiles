#!/usr/bin/env bash
# Install Linux (ubuntu) packages

declare -a APT_PKGS=(
    build-essential
    jq
    # fd-find
    fzf
    ripgrep
    tig
    zsh
)

declare -a SNAP_PKGS=(
    nvim
)

function all() {
    apt
    snap
}

function apt() {
    runApt "${APT_PKGS[@]}"
}

function snap() {
    runApt "${SNAP_PKGS[@]}"
}

# TODO: Run with sudo?
function runApt() {
    arr=("$@")
    for package in "${arr[@]}"; do
        apt install $package
    done
}

function runSnap() {
    arr=("$@")
    for package in "${arr[@]}"; do
        snap install $package
    done
}

function usage() {
cat<<EOD
Usage:
    apt  -- Install apt packages
    snap -- Install snap packages
    all  -- Install all packages
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
  apt)
    apt
    ;;
  snap)
    snap
    ;;
  all)
    all
    ;;
  *)
    usage
    ;;
esac

exit 0

