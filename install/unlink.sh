#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

echo -e "\nRemoving symlinks"
echo "=============================="
linkables=$( find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' )
for file in $linkables ; do
    target="$HOME/.$( basename $file ".symlink" )"
    if [ -e $target ]; then
        echo "Removing: ~${target#$HOME}"
        rm ${target#HOME}
    fi
done

