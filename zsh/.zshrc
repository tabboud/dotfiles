export DOTFILES=$HOME/.dotfiles
export ZSH_DIR=$HOME/.zsh
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

# my zsh settings
source "$ZSH/custom-omz.sh"

# FZF config
#TODO: LAZY LOAD this source
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Custom PROMPT overrides
[ -f ~/.prompt-overrides.zsh ] && source ~/.prompt-overrides.zsh

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
