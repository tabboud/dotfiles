# options that should be mostly pretty agreeable

# use ctrl-A, ctrl-E bindings
setopt emacs

# no c-s/c-q output freezing
setopt noflowcontrol
# allow expansion in prompts
setopt prompt_subst

# History
setopt append_history
setopt extended_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history

# display PID when suspending processes as well
setopt longlistjobs
# try to avoid the 'zsh: no matches found...'
setopt nonomatch
# report the status of backgrounds jobs immediately
setopt notify
# whenever a command completion is attempted, make sure the entire command path
# is hashed first.
setopt hash_list_all
# not just at the end
setopt completeinword
# use zsh style word splitting
setopt noshwordsplit
# allow use of comments in interactive code
setopt interactivecomments

setopt extended_glob

# avoid "beep"ing
setopt nobeep

# don't push the same dir twice.
setopt pushd_ignore_dups

# Don't send SIGHUP to background processes when the shell exits.
#setopt nohup

# Make the up and down arrow keys search history
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
