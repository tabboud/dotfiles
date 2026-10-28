# `.zshenv' is sourced on all invocations of the shell, unless the -f option is set.
# It should contain commands to set the command search path, plus other important environment variables.
# `.zshenv' should not contain commands that produce output or assume the shell is attached to a tty.

# TODO: Ensure -aU is valid on all platforms
typeset -aU path

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"

# Ubuntu's /etc/zsh/zshrc runs its own compinit, dumping into $ZDOTDIR, unless this is set.
# Export it since shells that inherit ZDOTDIR, like new tmux panes, do not read this file.
export skip_global_compinit=1

