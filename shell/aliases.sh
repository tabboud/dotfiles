# Cross platform aliases

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # OS X `ls`
    colorflag="-G"
fi

# Alias neovim if it exists
if [[ -n "$(command -v nvim)" ]]; then
    alias vim="nvim"
fi

if [[ -n "$(command -v rg)" ]]; then
    alias rg="rg -i"
fi

# Filesystem aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias l="ls -lh ${colorflag}"
alias la="ls -lAh ${colorflag}"
alias ltr="ls -ltrh ${colorflag}"
alias ls="ls ${colorflag}"
alias rmf="rm -rf"

# Git
alias g="git"
alias gs="git status"
alias lg="lazygit log"

# Helpers
alias grep='grep --color=auto'
alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

# IP addresses
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Trim new lines and copy to clipboard
alias trimcopy="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"
# Empty the Trash on all mounted volumes and the main HDD
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; rm -rfv ~/.Trash"
