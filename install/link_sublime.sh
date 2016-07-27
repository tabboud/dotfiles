#!/usr/bin/env bash
# link sublime text into osx

SUBLIME_DOTFILES=$HOME/.dotfiles/sublime
SUBLIME_DIR="${HOME}/Library/Application Support/Sublime Text 3/Packages/User"

echo -e "\nCreating Sublime Symlinks"
echo "=============================="

find "$SUBLIME_DIR" -iname "*.sublime-*" | while read f
do
    target="$SUBLIME_DIR"/$(basename "$f")
    if [ -e "$target" ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for $f"
        ln -s "$f" "$target"
    fi
done
