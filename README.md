# Dotfiles

## Contents

Configurations for:
+ vim
+ zsh (using oh-my-zsh)
+ emacs
+ tmux
+ git
+ osx
+ Homebrew files (brew.sh)

## Install

1. `git clone https://github.com/tdabboud/dotfiles.git ~/.dotfiles`
2. `cd ~/.dotfiles`
3. `./install.sh <command>`
```
Where <command> is one of:
  * bootstrap -- install software packages
  * dotfiles  -- link all dotfiles
  * all       -- all of the above
 ```

## Custom Settings

- Git specific settings go in: `~/.gitconfig.local`
- Shell/exports/env settings go in: `~/.custom.local`

## Un-Install

- To remove all linked dotfiles, run the following: `./install.sh uninstall`

