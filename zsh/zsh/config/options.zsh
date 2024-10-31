# History options
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Share history between sessions
setopt share_history

# Truecolor support
if [[ $(tput colors 2>/dev/null) == "256" ]]; then
    COLORTERM="truecolor"

    export MANPAGER='less -R --use-color -Du51 -Dd83 -DP4.7 -DE4.7 -DS4.7'
fi

# Use Neovim for man pages
[ -x /usr/bin/nvim ] && export MANPAGER='nvim +Man!'

# GPG tty
GPG_TTY=$(tty)

# Disable terminal beep
unsetopt beep

# Set the key timeout
KEYTIMEOUT=1

# Set word delimeters to bash word delimeters
autoload -U select-word-style
select-word-style bash

# Use emacs keybinds
set -o emacs
