######################
### DESIGN CHANGES ###
######################

# panes
set -g pane-border-style fg=default
set -g pane-active-border-style fg=default
set -g pane-active-border-style bg=default

## Status bar design
# status line
#set -g status-utf8 on
set -g status-justify left
set -g status-bg default
set -g status-fg colour12
set -g status-interval 2

# messaging
set -g message-style fg=black,bg=yellow
set -g message-command-style fg=blue
set -g message-command-style bg=black

#window mode
setw -g mode-style fg=colour0,bg=colour6

# window status
setw -g window-status-format " #F#I:#W#F "
setw -g window-status-current-format " #F#I:#W#F "
setw -g window-status-format "#[fg=magenta]#[bg=black] #I #[bg=cyan]#[fg=colour8] #W "
setw -g window-status-current-format "#[bg=brightmagenta]#[fg=colour8] #I #[fg=colour8]#[bg=colour14] #W "
setw -g window-status-current-style fg=colour11,bg=colour0,dim
setw -g window-status-style bg=green,fg=black,reverse

# loud or quiet?
#set-option -g visual-activity off
#set-option -g visual-bell off
#set-option -g visual-silence off
#set-window-option -g monitor-activity off
#set-option -g bell-action none

#set -g default-terminal "screen-256color"

# The modes {
setw -g clock-mode-colour colour135
# setw -g mode-stlye attr=bold
#setw -g mode-fg colour196
#setw -g mode-bg colour238

# }

# The statusbar {

set -g status-position bottom
set -g status-style bg=colour234,dim,fg=colour137
set -g status-left ''
#set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
set -g status-right 'Batt: #(~/.bin/battery_indicator.sh) | %a %h-%d %H:%M '
set -g status-right-length 50
set -g status-left-length 20

# setw -g window-status-current-fg colour81
setw -g window-status-current-style bg=colour238,bold
setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '

setw -g window-status-style fg=colour138,bg=colour235,none
setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

setw -g window-status-bell-style fg=colour255,bg=colour1,bold

# }
# The messages {

set -g message-style fg=colour232,bg=colour166,bold

# }
