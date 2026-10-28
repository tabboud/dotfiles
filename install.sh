#!/usr/bin/env bash

# Sets up a fresh machine by installing software packages and linking the dotfiles.
# Afterwards, use dots to manage them.
exec "$(dirname "${BASH_SOURCE[0]}")/home/.bin/dots" all "$@"
