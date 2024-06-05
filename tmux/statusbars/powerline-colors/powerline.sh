#!/usr/bin/env bash

# Status bar with powerline fonts and symbols
# Based off of https://github.com/wfxr/tmux-power and https://github.com/erikw/tmux-powerline
#
# This is a bash script which sets the status line on startup. Should be loaded via 'run-shell'

# Load the colors
#source ${XDG_CONFIG_HOME}/tmux/statusbars/dynamic/powerline-colors/moon.sh
source ${XDG_CONFIG_HOME}/tmux/statusbars/dynamic/powerline-colors/nord.sh


# Create variables for the symbols
rarrow=""
larrow=""
user_icon=""
session_icon="♢"
calendar_icon=""

# Set the status bar to referesh every second (this updates the clock)
tmux set -gq status-interval 1

# Allow dynamic window renaming
tmux set -gq allow-rename on

# Have tmux set the terminal title
tmux set -gq set-titles on

# Set the title format
tmux set -gq set-titles-string "#W"

# Set the base colors
tmux set -gq status-style bg="$c1",fg="$c2"

# Set the status lengths
tmux set -gq status-left-length 160
tmux set -gq status-right-length 160

# Set the left status items
tmux set -gq status-left "#[fg=$c1,bg=$c3,bold] $user_icon $USER@#h "
tmux set -gqa status-left "#[fg=$c3,bg=$c2,nobold]$rarrow"
tmux set -gqa status-left "#[fg=$c3,bg=$c2] $session_icon #S "
tmux set -gqa status-left "#[fg=$c2,bg=$c1]$rarrow"

# Set the right status items
tmux set -gq status-right "#[fg=$c2]$larrow"
tmux set -gqa status-right "#[fg=$c3,bg=$c2]  %T %Z "
tmux set -gqa status-right "#[fg=$c3,bg=$c2]$larrow"
tmux set -gqa status-right "#[fg=$c1,bg=$c3] $calendar_icon #(date +'%a %b %d %Y') "

# Set the inactive window status format
tmux set -gq window-status-format "#[fg=$c1,bg=$c2]$rarrow"
tmux set -gqa window-status-format "#[fg=$c3,bg=$c2] (#I) #W#F "
tmux set -gqa window-status-format "#[fg=$c2,bg=$c1]$rarrow"

# Set the current window status format
tmux set -gq window-status-current-format "#[fg=$c1,bg=$c3]$rarrow"
tmux set -gqa window-status-current-format "#[fg=$c1,bg=$c3,bold] (#I) #W#F "
tmux set -gqa window-status-current-format "#[fg=$c3,bg=$c1,nobold]$rarrow"

# Set the style for the windows
tmux set -gq window-status-style "fg=$c3,bg=$c1,none"

# Set the style for the last active window
tmux set -gq window-status-last-style "fg=$c3,bg=$c1,bold"

# Set the style for the activity
tmux set -gq window-status-activity-style "fg=$c3,bg=$c1,bold"

# Set the status separator
tmux set -gq window-status-separator ""
