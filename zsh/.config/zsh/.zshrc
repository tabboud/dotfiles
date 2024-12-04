export DOTFILES=$HOME/.dotfiles
export PATH=$HOME/.bin:/usr/local/bin:/usr/local/sbin:$PATH
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

# FZF config
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
fi

# Custom PROMPT overrides
[ -f ~/.prompt-overrides.zsh ] && source ~/.prompt-overrides.zsh
source $ZDOTDIR/lib/prompt.zsh

# Load all shell specific settings before the custom settings
for file in "$DOTFILES"/shell/*; do
    source "$file"
done
unset file

# Load all custom settings
# ~/.path   -> extend the PATH env variable
# ~/.custom -> custom settings
for file in ~/.{path,custom.local}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done
unset file

# Reload the zsh config
alias reload!='source $ZDOTDIR/.zshrc'
