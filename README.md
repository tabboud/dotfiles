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


## Custom Config

```sh
# Configure the CDPATH to "cd" to places without the full path
# Example: easily cd to Go repos under "$GOPATH/src/github.com"
export CDPATH=$CDPATH:$GOPATH/src/github.com

# Env vars used in dotfiles

# Setup the Github Enterprise organization for easy cloning via gh
export GHE_ORG="github.company.com"

# whitespace separated list of paths to search for Go repos
export GO_SEARCH_PATHS="$GOPATH/src/github.com $GOPATH/src/github.company.com"
```
