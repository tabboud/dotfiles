# Functions that leverage FZF

# Cd to a Go repo via fzf.
#
# Finds all repositories under $ROOT_CODE_DIR (if set) or $GOPATH/src, displays
# them as org/repo, and provides selection through fzf. Any arguments are used as
# the initial query, and a single match is selected automatically.
#
# Ctrl-c can be used to cancel the selection.
gocd() {
  local gorepo
  gorepo="$(find "${ROOT_CODE_DIR:-$GOPATH/src}" -mindepth 3 -maxdepth 3 -type d 2>/dev/null \
    | fzf -d / --with-nth=-2.. --query="$*" --select-1 --reverse --height=20 --border)"
  if [[ -n $gorepo ]]; then
    cd -- "$gorepo"
  fi
}

c() {
  gocd "$@"
}

# Create a new tmux session or switch to an existing one by selecting one of the
# listed sessions sorted by most recently attached.
#
# Commands:
# tm: select an open tmux session via fzf, or type a new name to create one
# tm <session-name>: Attaches to <session-name> or creates it
tm() {
  local change
  [[ -n $TMUX ]] && change="switch-client" || change="attach-session"
  if [[ -n $1 ]]; then
    # tmux cannot target session names containing "." or ":", so replace them.
    local name=${1//[.:]/_}
    # The "=" prefix forces an exact match, otherwise tmux picks any session starting with the name.
    tmux has-session -t "=$name" 2>/dev/null || tmux new-session -d -s "$name" || return
    tmux "$change" -t "=$name"
    return
  fi

  # list sessions by most recently attached first, skipping the current one
  # Uses the "session_last_attached" format as the sorting field but strips off this timestamp
  # before presenting the selection.
  # With --print-query the typed query is the first line and the selection (if any) the second,
  # so a query that matches nothing, or alt-enter, falls through to creating a new session.
  local current out session
  [[ -n $TMUX ]] && current=$(tmux display-message -p '#S')
  out=$(tmux list-sessions -F "#{session_last_attached} #{session_name}" 2>/dev/null \
    | sort -rn | cut -d' ' -f2- | grep -vxF -- "$current" \
    | fzf --print-query --bind=alt-enter:print-query \
        --prompt="Select tmux session: " --header="enter: select or create, alt-enter: create from query" \
        --reverse --height=20 --border)
  # 0 is a selection, 1 is no match, anything else is a cancel or error
  (( $? > 1 )) && return
  # Keep the last line, which is the selection or the query if nothing was selected
  session=${out##*$'\n'}
  [[ -n $session ]] && tm "$session"
}

# Lists local branches by most recent commit, skipping any checked out in a worktree.
_gitLocalBranches() {
  git for-each-ref --sort=-committerdate refs/heads/ \
    --format="%(if)%(worktreepath)%(then)%(else)%(refname:short)%(end)" | grep -v '^$'
}

# Delete local git branches.
#
# Select the branches to delete via <tab>, then confirm. Branches checked out in a
# worktree, including the current one, are not listed since git refuses to delete them.
gdel() {
  local branches yn
  branches=$(_gitLocalBranches \
    | fzf --multi --exit-0 --prompt="Delete branches: " --header="tab: select, enter: confirm" \
        --preview="git log --oneline --color=always -n 20 {} --" \
        --reverse --height=20 --border) || return
  printf '%s\n' "$branches"
  if ! read -q "yn?Force delete these branches? [y/N] "; then
    echo
    return 1
  fi
  echo
  git branch -D ${(f)branches}
}

# Switch between local git branches, most recently committed first.
#
# Commands:
# gswitch: select a branch via fzf and switch to it
# gswitch -s: stash local changes before switching
gswitch() {
  local opt autostash=0 header="Select a branch to switch to" branch
  while getopts "s" opt; do
    case $opt in
      s)
        autostash=1
        header+=" (autostash)"
        ;;
      *)
        return 1
        ;;
    esac
  done

  branch=$(_gitLocalBranches \
    | fzf --exit-0 --prompt="Switch branch: " --header="$header" \
        --preview="git log --oneline --color=always -n 20 {} --" \
        --reverse --height=20 --border) || return
  if (( autostash )); then
    git stash || return
  fi
  git switch "$branch"
}

# Checkout a GitHub PR by number, or select one of the open PRs via fzf.
ghco() {
  local help_message="Usage: ghco [PR_NUMBER]

Options:
  -h, --help     Show this help message and exit

Description:
  Use ghco to checkout a specified pull request (PR) using the GitHub CLI.
  If no PR_NUMBER is provided, you will be prompted to select from a list of open PRs."
  check_help "$help_message" "$@" && return

  local pr=$1 prs selection
  if [[ -z $pr ]]; then
    # The title goes last so a long one cannot push the other columns out of view.
    prs=$(gh pr list --json number,headRefName,baseRefName,title \
      --jq '.[] | [.number, .headRefName, .baseRefName, .title] | @tsv') || return
    if [[ -z $prs ]]; then
      echo "No open PRs"
      return 1
    fi
    selection=$(printf '%s\n' "$prs" | column -t -s $'\t' \
      | fzf --prompt="Select PR to checkout: " --reverse --height=20 --border) || return
    pr=${selection%% *}
  fi
  gh pr checkout "$pr"
}
