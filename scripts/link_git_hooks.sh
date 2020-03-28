#!/bin/bash
# copy dotfiles specific git-hooks

DOTFILES=$HOME/.dotfiles

echo -e "\nCreating symlinks"
echo "=============================="
for hook in $DOTFILES/.hooks/*; do
    target=$DOTFILES/.git/hooks/$( basename $hook )
    if [ -e $target ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for $hook"
        ln -s $hook $target
    fi
done

