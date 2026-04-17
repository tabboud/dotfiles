export DOTFILES=$HOME/.dotfiles

# Autoload all custom functions early so they are available throughout this file
fpath=("$ZDOTDIR/functions" $fpath)
autoload -Uz $ZDOTDIR/functions/*(.:t)

pathprepend /usr/local/sbin
pathprepend /usr/local/bin
pathprepend $HOME/.bin

export PAGER='less -R'
export HISTFILE="$ZDOTDIR/.zsh_history"

if command -v nvim 2>&1 > /dev/null; then
  export EDITOR='nvim'
  export GIT_EDITOR='nvim'
else
  export EDITOR='vim'
  export GIT_EDITOR='vim'
fi

# Create cache and completions dir and add to $fpath
mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# Add Homebrew to function path, if available
if command -v brew 2>&1 > /dev/null; then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

# Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit
# Save the location of the current completion dump file.
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump"
fi
compinit -u -C -d "${ZSH_COMPDUMP}"

# Load all of library config files
for config_file ($ZDOTDIR/lib/*.zsh); do
  source $config_file
done

# Allow '#' to be used for comments in interactive shells
setopt interactivecomments

# Ensure FZF keyboard completions work     
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
fi

# Custom PROMPT overrides
[ -f ~/.prompt-overrides.zsh ] && source ~/.prompt-overrides.zsh
source $ZDOTDIR/lib/prompt.zsh

# Load all custom settings
# ~/.custom -> custom settings
for file in ~/.{custom.local}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done
unset file

# Reload the zsh config
alias reload!='source $ZDOTDIR/.zshrc'
