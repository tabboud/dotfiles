# ZSH Theme - Preview: https://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

# Set for root or not
if [[ $UID -eq 0 ]]; then
    # local user_host='%{$terminfo[bold]$fg[red]%}%n@%m %{$reset_color%}'
    local user_symbol='#'
else
    # local user_host='%{$terminfo[bold]$fg[green]%}%n@%m %{$reset_color%}'
    local user_symbol='$'
fi

# local current_dir='%{$terminfo[bold]$fg[blue]%}%~ %{$reset_color%}'
# local current_dir="%{$terminfo[blue]%}%3~%{$reset_color%} "
local current_dir="%{$fg[cyan]%}%3~%{$reset_color%}"
local git_branch='$(git_prompt_info)'
local current_time='[%D{%y/%m/%f}|%@]'

PROMPT="╭─${user_host}${current_dir} ${git_branch}
╰─%B${user_symbol}%b "
# RPROMPT="%B${return_code}%b"
RPROMPT="${current_time}"

# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
# ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
