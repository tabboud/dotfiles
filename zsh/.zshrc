export DOTFILES=$HOME/.dotfiles
export ZSH_DIR=$HOME/.zsh
export EDITOR=vim
export PATH=$HOME/.bin:/usr/local/bin:/usr/local/sbin:$PATH

# oh-my-zsh settings
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME=""
DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh

# History
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# source all .zsh files inside of the $DOTFILES/zsh/ directory
for config ($HOME/.zsh/**/*.zsh) source $config

# FZF config
#TODO: LAZY LOAD this source
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use ag instead of find for fzf
export FZF_DEFAULT_COMMAND='ag -g ""'

# Load all custom settings
# ~/.path   -> extend the PATH env variable
# ~/.custom -> custom settings
for file in ~/.{path,custom.local}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done
unset file

# Load all shell specific settings
# ~/.aliases.sh     -> common aliases
# ~/.functions.sh   -> common functions
for file in $DOTFILES/shell/*; do
    source "$file"
done
unset file

os_name=$(uname -s)
# remap capslock to ctrl on linux
if [[ "$os_name" == "Linux" ]]; then
    setxkbmap -layout us -option ctrl:nocaps
fi

#####################
# zsh specific alias
#####################

# Reload the zsh config
alias reload!='source $HOME/.zshrc'

