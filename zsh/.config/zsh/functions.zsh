#!/usr/bin/env zsh

# Prepend a path to $PATH IFF it doesn't exist.
#
# Ex: prepend_path path1 -> path1:$PATH
function prepend_path() {
    local ARG=$1
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="$ARG${PATH:+":$PATH"}"
    fi
}

