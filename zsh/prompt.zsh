# See: https://git-scm.com/book/sv/v2/Bilaga-A%3A-Git-in-Other-Environments-Git-in-Zsh
# Autoload zsh's `add-zsh-hook` and `vcs_info` functions
# (-U autoload w/o substition, -z use zsh style)
autoload -Uz add-zsh-hook vcs_info

# Set prompt substitution so we can use the vcs_info_message variable
setopt prompt_subst

# Run the `vcs_info` hook to grab git info before displaying the prompt
add-zsh-hook precmd vcs_info

# Style the vcs_info message
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '%b'

# Run the `vcs_info` hook to grab git info before displaying the prompt
# add-zsh-hook precmd vcs_info
autoload -U colors && colors
local green="%{$fg_bold[green]%}"
local red="%{$fg_bold[red]%}"
local cyan="%{$fg_bold[cyan]%}"
local yellow="%{$fg_bold[yellow]%}"
local reset="%{$reset_color%}"

function git_branch_colored() {
  vcs_info
  # Use the branch name if it exists and fallback to the current commit
  local git_branch="$vcs_info_msg_0_"
  if [ -n "${git_branch}" ]; then
    if [ -n "$(git status --porcelain)" ]; then
      local gitstatuscolor=$red
    else
      local gitstatuscolor=$green
    fi
    echo "${gitstatuscolor}(${git_branch})${reset}"
  else
    echo ""
  fi
}

# # Enable command substitution in prompt
# setopt prompt_subst

# # See "man zshmisc" for ternary operator
# local suspended_jobs="%(1j.$yellow⏺ ${reset}.)"
local current_dir="$cyan%3~${reset}"
# local prompt_symbol='❯'
# if [[ $UID -eq 0 ]]; then
#     prompt_symbol='#'
# fi
# # local last_command_output="%(?.%(!.$red.$green).$yellow)"
# local colored_prompt_symbol="%(?..$red)${prompt_symbol}${reset}"
local user_host=${PROMPT_OVERRIDE_USER:-""}

# # Left Prompt
PROMPT="${user_host}${current_dir}$(git_branch_colored)"
# PROMPT="${suspended_jobs}${user_host}${current_dir}$(git_branch_colored)
# ${colored_prompt_symbol} "

# # Right Prompt
# RPROMPT=""
# # RPROMPT="%B${return_code}%b"
# # local current_time='[%D{%y/%m/%f}|%@]'
# # RPROMPT="${current_time}"
