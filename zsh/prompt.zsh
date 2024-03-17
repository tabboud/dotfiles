local reset="%{$reset_color%}"

function git_branch_colored() {
  # Use the branch name if it exists and fallback to the current commit
  local ref=$(git symbolic-ref --short -q HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null)
  if [ -n "${ref}" ]; then
    if [ -n "$(git status --porcelain)" ]; then
      local gitstatuscolor='%F{red}'
    else
      local gitstatuscolor='%F{green}'
    fi
    echo "${gitstatuscolor} (${ref})$reset"
  else
    echo ""
  fi
}

# Enable command substitution in prompt
setopt prompt_subst

# See "man zshmisc" for ternary operator
local suspended_jobs="%(1j.%F{yellow}⏺ $reset.)"
local current_dir="%{$fg[cyan]%}%3~$reset"
local prompt_symbol='❯'
if [[ $UID -eq 0 ]]; then
    prompt_symbol='#'
fi
# local last_command_output="%(?.%(!.$red.$green).$yellow)"
local colored_prompt_symbol="%(?..%F{red})${prompt_symbol}$reset"
local user_host=${PROMPT_OVERRIDE_USER:-""}

# Left Prompt
PROMPT="${suspended_jobs}${user_host}${current_dir}$(git_branch_colored)
${colored_prompt_symbol} "

# Right Prompt
RPROMPT=""
# RPROMPT="%B${return_code}%b"
# local current_time='[%D{%y/%m/%f}|%@]'
# RPROMPT="${current_time}"
