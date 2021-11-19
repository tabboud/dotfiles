# Dotfiles

## Contents

Configurations for:
+ git
+ tmux
+ vim/neovim
+ zsh

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

