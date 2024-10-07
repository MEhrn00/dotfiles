# History options
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Share history between sessions
setopt share_history

# Truecolor support
if [[ $(tput colors 2>/dev/null) == "256" ]]; then
    COLORTERM="truecolor"

    # Colored man pages
    LESS_TERMCAP_mb=$'\E[01;32m'
    LESS_TERMCAP_md=$'\E[01;32m'
    LESS_TERMCAP_me=$'\E[0m'
    LESS_TERMCAP_se=$'\E[0m'
    LESS_TERMCAP_so=$'\E[01;47;34m'
    LESS_TERMCAP_ue=$'\E[0m'
    LESS_TERMCAP_us=$'\E[01;36m'
fi

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

