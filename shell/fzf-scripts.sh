# Functions that leverage FZF

# fuzzy grep open via ag
vg() {
  local file

  file="$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1}')"

  if [[ -n $file ]]
  then
     vim $file
  fi
}

# Cd to a Go repo via fzf.
#
# Finds all repositories under $GOPATH/src, strips out only the org/repo name and provides selection through fzf.
# Ctrl-c can be used to cancel the selection.
gocd() {
    local gorepo

    gorepo="$(find $GOPATH/src -type d -maxdepth 3 -mindepth 1 | fzf -d / --with-nth=-2..)"
    if [[ -n $gorepo ]]; then
        cd $gorepo
    fi
}

# Create a new tmux session or switch to an existing one.
#
# Commands:
# tm: select an open tmux session via fzf
# tm <session-name>: Attaches to <session-name> or creates it
tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}
