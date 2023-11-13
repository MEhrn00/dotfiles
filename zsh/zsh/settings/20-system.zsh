# General ZSH settings

# Disable terminal beep
unsetopt beep

# Set the key timeout
KEYTIMEOUT=1

# Set the dircolors if the file exists
if [ -f "${XDG_CONFIG_HOME}/dircolors" ]; then
    eval "$(dircolors ${XDG_CONFIG_HOME}/dircolors)"
elif [ -f "${HOME}/.dircolors" ]; then
    eval "$(dircolors ${HOME}/.dircolors)"
fi

# Set word delimeters to bash word delimeters
autoload -U select-word-style
select-word-style bash
