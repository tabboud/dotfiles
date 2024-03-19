# See: https://git-scm.com/book/sv/v2/Bilaga-A%3A-Git-in-Other-Environments-Git-in-Zsh
autoload -U colors && colors
local green="%{$fg[green]%}"
local red="%{$fg[red]%}"
local cyan="%{$fg[cyan]%}"
local yellow="%{$fg[yellow]%}"
local reset="%{$reset_color%}"

function git_branch_colored() {
  # Use the branch name. If that does not exist, then check if the current commit
  # points to a tag, otherwise just use the commit hash.
  local ref=""
  local git_branch=$(git symbolic-ref --short -q HEAD 2>/dev/null)
  if [[ -n "${git_branch}" ]]; then
      ref=$git_branch
  else
      local git_commit=$(git rev-parse --short HEAD 2>/dev/null)
      ref=$git_commit
      local git_tag=$(git tag --points-at="${git_commit}" 2>/dev/null)
      if [[ -n "${git_tag}" ]]; then
          ref=$git_tag
      fi
  fi
  if [ -n "${ref}" ]; then
    if [ -n "$(git status --porcelain)" ]; then
      local gitstatuscolor=$red
    else
      local gitstatuscolor=$green
    fi
    echo "${gitstatuscolor}(${ref})${reset}"
  else
    echo ""
  fi
}

# # Enable command substitution in prompt
setopt prompt_subst

# # See "man zshmisc" for ternary operator
local suspended_jobs="%(1j.$yellow⏺ ${reset}.)"
local current_dir="$cyan%3~${reset}"
local prompt_symbol='❯'
if [[ $UID -eq 0 ]]; then
    prompt_symbol='#'
fi
local last_command_output="%(?.%(!.$red.$green).$yellow)"
local colored_prompt_symbol="%(?..$red)${prompt_symbol}${reset}"
local user_host=${PROMPT_OVERRIDE_USER:-""}

# # Left Prompt
PROMPT='${user_host}${current_dir} $(git_branch_colored) ${suspended_jobs}
${colored_prompt_symbol} '

# # Right Prompt
# RPROMPT=""
# # RPROMPT="%B${return_code}%b"
# # local current_time='[%D{%y/%m/%f}|%@]'
# # RPROMPT="${current_time}"
