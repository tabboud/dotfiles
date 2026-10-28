# Dotfiles

## Contents

Configurations for:
+ zsh, with aliases and functions in `shell/`
+ neovim and vim
+ tmux
+ git and tig
+ Ghostty
+ Hammerspoon (macOS only)
+ lazygit, gh, and cheat

Scripts in `home/.bin` are linked to `~/.bin`, which is on the `PATH`.

## Install

1. `git clone https://github.com/tdabboud/dotfiles.git ~/.dotfiles`
2. `~/.dotfiles/install.sh`

`install.sh` installs software packages and links the dotfiles. Afterwards, open a new shell and use
`dots <command>` from any directory to manage them:
```
Where <command> is one of:
  * bootstrap -- install software packages
  * link      -- link all dotfiles
  * unlink    -- remove all dotfile symlinks
  * status    -- show the state of every link
  * all       -- install software packages and link all dotfiles
  * update    -- pull the latest dotfiles, then run all
  * edit      -- fuzzy-find a dotfile and open it in $EDITOR
 ```

Pass `-n` or `--dry-run` to any command, or to `install.sh`, to print the commands it would run without changing
anything.

Software packages come from the `Brewfile` on macOS. On Ubuntu, `dots bootstrap` installs the `Aptfile` packages with
apt instead, skipping any the release does not provide. It also installs Neovim with snap and makes zsh the login
shell.

## Linking

`dots link` symlinks the dotfiles into `$HOME` using only bash and `ln`, so nothing needs to be installed first.

- Every entry in `config/` is linked into `~/.config`. For example, `config/nvim` links to `~/.config/nvim`.
- Every dotfile in `home/` is linked into `$HOME`. For example, `home/.zshenv` links to `~/.zshenv`.

To add a config, create it under `config/` or `home/` and run `dots link`. Paths listed in `DARWIN_ONLY` in
`scripts/link.sh` are only linked on macOS. Existing files at a link target are moved to a timestamped `.bak` file
before being replaced, and broken links that point into this repo, for example after a config is moved or deleted,
are removed.

## Custom Settings

- Git specific settings go in: `$HOME/.gitconfig.local`
- Shell/exports/env settings go in: `$HOME/.custom.local`
- Tmux settings go in: `$HOME/.tmux.local`
- ZSH PROMPT overrides go in: `$HOME/.prompt-overrides.zsh`

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

The following environment variables are supported zsh PROMPT overrides. These settings
should be placed in the prompt override file mentioned above.

```sh
# This updates the terminal PROMPT prefix with a custom value.
# Used in the custom zsh theme.
# Defaults to "" if not set.
export PROMPT_OVERRIDE_USER="[PROD]"
```

## Overrides

### Hammerspoon

Overrides can be supplied by creating an `overrides.lua` module at the following path. This path is already in
`.gitignore` so all changes will not be tracked. The lua module should return a Config object with all expected overrides set.

```
home/.hammerspoon/overrides.lua
```

## Un-Install

- To remove all linked dotfiles, run the following: `dots unlink`
