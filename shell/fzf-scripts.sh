# Functions that leverage FZF

# Cd to a Go repo via fzf.
#
# Finds all repositories under $ROOT_CODE_DIR (if set) or $GOPATH/src, strips out
# the org/repo name, and provides selection through fzf.
#
# Ctrl-c can be used to cancel the selection.
gocd() {
    local gorepo

    gorepo="$(find "${ROOT_CODE_DIR:-$GOPATH/src}" -maxdepth 3 -mindepth 1 -type d | fzf -d / --with-nth=-2.. --reverse --height=20 --border)"
    if [[ -n $gorepo ]]; then
        cd $gorepo
    fi
}

dots() {
    cd $DOTFILES
    files=$(fzf --reverse --height=20 --border)
    if [[ -n "$files" ]]; then
        ${EDITOR:-vim} "${files[@]}"
    fi
}

# Create a new tmux session or switch to an existing one by selecting one of the
# listed sessions sorted by most recently attached.
#
# Commands:
# tm: select an open tmux session via fzf
# tm <session-name>: Attaches to <session-name> or creates it
tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi

  # list sessions by most recently attached first
  # Uses the "session_last_attached" format as the sorting field but strips off this timestamp
  # before presenting the selection.
  session=$(tmux list-sessions -F "/#{session_last_attached}/#{session_name}" | sort -Vr | xargs basename | fzf --exit-0 --reverse --height=20 --border)
  tmux $change -t "$session" || echo "No sessions found."
}

# Delete git branches.
#
# Select all branches to be deleted locally via <tab>.
gdel() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" | fzf --multi --reverse --height=20 --border) &&
  git branch -D $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")

  return
  # TODO(tabboud): Add confirmation to delete
  while true; do
      read -p "Are you sure you want to delete these branches?" yn
      case "$yn" in
          [Yy]*)
              git pull $@;
              break
              ;;
          [Nn]*)
              exit
              ;;
          *)
              printf %s\\n "Please answer yes or no."
      esac
  done
}
