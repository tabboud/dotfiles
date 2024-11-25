export DOTFILES=$HOME/.dotfiles
# export ZSH_DIR=$HOME/.zsh
export ZSH=$DOTFILES/zsh
export EDITOR=vim
export PATH=$HOME/.bin:/usr/local/bin:/usr/local/sbin:$PATH

# Use bat for paging if available
if command -v bat &>/dev/null; then
  export PAGER='bat -p'
  export MANPAGER="sh -c 'col -bx | bat -plman'"
else
  export PAGER='less -R'
fi


# Set ZSH_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
if [[ -z "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="$ZSH/cache"
fi

# Create cache and completions dir and add to $fpath
mkdir -p "$ZSH_CACHE_DIR/completions"
(( ${fpath[(Ie)"$ZSH_CACHE_DIR/completions"]} )) || fpath=("$ZSH_CACHE_DIR/completions" $fpath)

# Add Homebrew to function path, if available
if command -v brew 2>&1 > /dev/null; then
  fpath=("$(brew --prefix)/share/zsh/site-functions" "$ZSH/functions" "$ZSH/completions" $fpath)
fi

# Load all stock functions (from $fpath files) called below.
autoload -U compaudit compinit
# Save the location of the current completion dump file.
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump"
fi
compinit -u -C -d "${ZSH_COMPDUMP}"

# Load all of library config files
for config_file ($ZSH/lib/*.zsh); do
  source $config_file
done

# Allow '#' to be used for comments in interactive shells
setopt interactivecomments

# FZF config
#TODO: LAZY LOAD this source
if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
fi

# Custom PROMPT overrides
[ -f ~/.prompt-overrides.zsh ] && source ~/.prompt-overrides.zsh
source $ZSH/prompt.zsh

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

# os_name=$(uname -s)
# remap capslock to ctrl on linux
# if [[ "$os_name" == "Linux" ]]; then
#     setxkbmap -layout us -option ctrl:nocaps
# fi

#====================
# zsh specific alias
#====================

# Reload the zsh config
alias reload!='source $HOME/.zshrc'
