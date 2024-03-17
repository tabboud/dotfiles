# ZSH Theme - Preview: https://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

# Set for root or not
if [[ $UID -eq 0 ]]; then
    # local user_host='%{$terminfo[bold]$fg[red]%}%n@%m %{$reset_color%}'
    local user_symbol='#'
else
    # local user_host='%{$terminfo[bold]$fg[green]%}%n@%m %{$reset_color%}'
    # local user_symbol=';'
    local user_symbol='❯'
fi

if [[ -n $PROMPT_OVERRIDE_USER ]]; then
    local user_host=${PROMPT_OVERRIDE_USER}
fi

function git_branch() {
    branch=$(__git_prompt_git branch --show-current)
    if [[ -z $branch ]]; then
        :
    else
        echo ' ('$branch') '
    fi
}

# indicate a job (for example, vim) has been backgrounded
# If there is a job in the background, display a ✱
suspended_jobs() {
    local sj
    sj=$(jobs 2>/dev/null | tail -n 1)
    if [[ $sj == "" ]]; then
        echo ""
    else
        echo "%{%F{208}%}✱%f "
    fi
}

git_branch_test_color() {
  # Use the branch name if it exists and fallback to the current commit
  local ref=$(git symbolic-ref --short -q HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null)
  if [ -n "${ref}" ]; then
    if [ -n "$(git status --porcelain)" ]; then
      local gitstatuscolor='%F{red}'
    else
      local gitstatuscolor='%F{green}'
    fi
    echo "${gitstatuscolor} (${ref})"
  else
    echo ""
  fi
}
# Enable command substitution in prompt
setopt prompt_subst
# PROMPT='%9c$(git_branch_test_color)%F{none} %# '

# local current_dir='%{$terminfo[bold]$fg[blue]%}%~ %{$reset_color%}'
# local current_dir="%{$terminfo[blue]%}%3~%{$reset_color%} "
local current_dir="%{$fg[cyan]%}%3~%{$reset_color%}"
# local git_branch='$(__git_prompt_git branch --show-current)'
local current_time='[%D{%y/%m/%f}|%@]'

# Main Prompt
# PROMPT="╭─${user_host}${current_dir}
# ╰─%B${user_symbol}%b "
PROMPT='${user_host}${current_dir}$(git_branch_test_color)%F{none}
$(suspended_jobs)${user_symbol} '

# Right-Side Prompt
RPROMPT=""
# RPROMPT="%B${return_code}%b"
# RPROMPT="${current_time}"

# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
# ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
