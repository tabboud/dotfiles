# Dotfiles

## Contents

Configurations for:
+ git
+ tmux
+ neovim
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

- Git specific settings go in: `$HOME/.gitconfig.local`
- Shell/exports/env settings go in: `$HOME/.custom.local`
- Tmux settings go in: `$HOME/.tmux.local`

## Environment Variables

The following lays out environment variables used throughout the dotfiles/scripts.
These should be set in the custom config files mentioned above.

```sh
# Setup the Github Enterprise organization for easy cloning via gh
# Used in the `gheclone` function
export GHE_ORG="github.company.com"

# Path to the root code directory
# My directory structure for code, regardless of language, follows the GOPATH structure.
# Ex:
#   $ <root_code_dir>/<enterprise>/<org>/<repo>
#   $ /Users/tabboud/src/github.com/tabboud/dotfiles
#
# If set, used as the main search path in `gocd`
# Also used in `ghclone` and `gheclone` as the location to clone repos
export ROOT_CODE_DIR="$HOME/src"

# Regular GOPATH setting
# Used as the default search path in `gocd` if `$ROOT_CODE_DIR` is not set
export GOPATH="$HOME"

```

## Un-Install

- To remove all linked dotfiles, run the following: `./install.sh uninstall`
