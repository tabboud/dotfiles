#!/bin/bash
# link sublime text into osx

SUBLIME=$HOME/.dotfiles/sublime
SUBLIME_DIR="${HOME}/Library/Application Support/Sublime Text 3/Packages"

echo -e "\nCreating Sublime Symlinks"
echo "=============================="
linkables=$( find -H "$SUBLIME" -maxdepth 3 -name '*.symlink' )
for file in $linkables ; do
    target="$SUBLIME_DIR/.$( basename $file ".symlink" )"
    if [ -e $target ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for $file"
        ln -s $file $target
    fi
done
