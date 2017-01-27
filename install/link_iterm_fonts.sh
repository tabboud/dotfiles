#!/usr/bin/env bash
# link any iterm fonts into $HOME/Library/Fonts

FONTS_DIR=$HOME/.dotfiles/iterm/fonts
OSX_FONTS_DIR="${HOME}/Library/Fonts"

echo -e "\nCreating Font Symlinks"
echo "=============================="

fonts=$( find -H "$FONTS_DIR" -name '*.ttf' )
for file in $fonts; do
    target="$OSX_FONTS_DIR/$( basename $file )"
    if [ -e $target ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for $file"
        ln -s $file $target
    fi
done
