# General ZSH settings

# Disable terminal beep
unsetopt beep

# Set the key timeout
KEYTIMEOUT=1

# Set word delimeters to bash word delimeters
autoload -U select-word-style
select-word-style bash

# Use emacs keybinds
set -o emacs
