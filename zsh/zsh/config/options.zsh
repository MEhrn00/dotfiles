# History options
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Share history between sessions
setopt share_history

# Truecolor support
if [[ $COLORTERM = *(24bit|truecolor)* ]] || tput colors 2>/dev/null | grep -q '256'; then
    export MANPAGER='less -R --use-color -Du51 -Dd83 -DP4.7 -DE4.7 -DS4.7'
    zmodload zsh/nearcolor
fi

# Use bat as a regular pager
if [ -x /usr/bin/bat ] || [ -x /usr/local/bin/bat ]; then
    export PAGER='bat'
fi

# Use nvim as a man page pager
if [ -x /usr/bin/nvim ] || [ -x /usr/local/bin/nvim ]; then
    export MANPAGER='nvim +Man!'
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

# Connect to existing SSH agent if not already connected
if [ -z $SSH_AUTH_SOCK ]; then
    if [ -S $XDG_RUNTIME_DIR/ssh-agent.socket ]; then
        export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
        export SSH_AGENT_PID=$(pgrep -f "ssh-agent.*$SSH_AUTH_SOCK")
    elif [ -S $XDG_RUNTIME_DIR/gcr/ssh ]; then
        export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
        export SSH_AGENT_PID=$(lsof -U | grep $SSH_AUTH_SOCK | grep -v systemd | cut -d' ' -f2)
    elif [ -S $XDG_RUNTIME_DIR/openssh_agent ]; then
        export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/openssh_agent
        export SSH_AGENT_PID=$(pgrep -f "ssh-agent.*$SSH_AUTH_SOCK")
    fi
fi
