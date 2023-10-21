### Real zsh init. Configures general settings then bootstraps other misc settings

# Set the history settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Disable terminal beep
unsetopt beep

# Share history between sessions
setopt share_history

# Set the key timeout
KEYTIMEOUT=1

# Set the dircolors if the file exists
if [ -f ~/.dircolors ]; then
    eval "$(dircolors ~/.dircolors)"
fi

# Set up completion settings
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
bindkey '^[[Z' reverse-menu-complete

# Load prompt customization plugin
autoload -Uz promptinit
promptinit

# Set word delimeters to bash word delimeters
autoload -U select-word-style
select-word-style bash

## Add the git status in the prompt
autoload -Uz vcs_info
setopt promptsubst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ":U"
zstyle ':vcs_info:git:*' formats "(%s)-[%b%u]%c"

# Better make completion
zstyle ':completion::complete:make::' tag-order 'targets variables'

# Keybind to toggle long/short prompt
PROMPT_OPTION=short

toggle_prompt_option() {
    if [ "$PROMPT_OPTION" = short ]; then
        PROMPT_OPTION=long
    else
        PROMPT_OPTION=short
    fi

    draw_prompt
    zle reset-prompt
}

zle -N toggle_prompt_option
bindkey "\C-o" toggle_prompt_option

# Configure the prompt
RETURN_CODE="%(?..%{%F{red}%}%? )%{%F{white}%}"
draw_prompt() {
    vcs_info
    PROMPT=""
    if [[ "$VIRTUAL_ENV" != '' ]]
    then
        PROMPT+="(%{%F{red}%}`basename $VIRTUAL_ENV`%{%F{white}%}) "
    fi

    PROMPT_PATH="%{%F{blue}%}"

    if [ "$PROMPT_OPTION" = short ]; then
        PROMPT_PATH+="%~"
    else
        PROMPT_PATH+="$(echo $PWD | sed -E "s|$HOME|~|g" | sed -E 's/(\w)[^\/]+\//\1\//g')"
    fi

    PROMPT_PATH+="%{%F{white}%}"

    PROMPT+="%{%F{green}%}%n@%m%{%F{white}%} :: $PROMPT_PATH "


    if [[ "${vcs_info_msg_0_}" != '' ]]
    then
        PROMPT+='%{%F{yellow}%}${vcs_info_msg_0_}%{%F{white}%} '
    else
        PROMPT+=''
    fi

    PROMPT+="$RETURN_CODE>> "
}

precmd_functions+=(draw_prompt)

# TODO: preexec_function which sets the terminal/tmux title to long running commands and then
# switches the title back to the regular prompt when finished. This setting will depend on
# what `TERM` is set, if there is a tmux session and whether or not in WSL.
#testing() {
#    echo "lol"
#}
#preexec_functions+=(testing)

# Alias to disable aslr in a new session since setting /proc/sys/kernel/randomize_va_space
# for system wide aslr is a terrible practice
alias disable_aslr="setarch `uname -m` -R /bin/bash"

# Helpful aliases
alias ls="ls --color=auto"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias grep="grep --color=auto"
alias ec="emacsclient"


# Zsh function containing common excludes for ctags and to parse .gitignore and .ctagsignore
# files for excludes list
tgen() {
    # Make default excludes for ctags (only need .idea because everything is in gitignore)
    local excludes="--exclude=.git"

    # Add global gitignore to tagslist
    if [[ -f "$HOME/.config/git/ignore" ]]; then
        while IFS= read -r line; do
            excludes+=" --exclude=$line"
        done < "$HOME/.config/git/ignore"
    fi

    # Add local .gitignore if exists
    if [[ -f ".gitignore" ]]; then
        while IFS= read -r line; do
            excludes+=" --exclude=$line"
        done < ".gitignore"
    fi

    # Add .ctagsignore if exists
    if [[ -f ".ctagsignore" ]]; then
        while IFS= read -r line; do
            excludes+=" --exclude=$line"
        done < ".ctagsignore"
    fi

    if [[ "$1" == "-e" ]]; then
        ctags -e -R $(echo -n $excludes) .
    else
        ctags -R $(echo -n $excludes) .
    fi
}

# pwninit with template
alias pwninit="pwninit --template-path ~/.config/nvim/snippets/pwninit-template.py --template-bin-name e"

# CTF flag
alias flag="printf 'flag{%s}' $(head /dev/urandom | md5sum | cut -d' ' -f1)"

# Kubernetes completion
source <(kubectl completion zsh)

# Set go path to a hidden dir
export GOPATH=$HOME/.go

# GPG CLI
export GPG_TTY=$(tty)

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

# Add .local/bin and .go/bin to path
export PATH=$PATH:$HOME/.local/bin:$GOPATH/bin

# Vagrant setup
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/Users/matth/"
export VAGRANT_DEFAULT_PROVIDER="hyperv"

# AWS CLI
export AWS_DEFAULT_PROFILE='mehrn00'
export AWS_PAGER='less -F -X'

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Set the Bitwarden CLI data directory
export BITWARDENCLI_APPDATA_DIR="$HOME/.config/bitwarden"

# Set up SSH agent
# First, try loading the SSH agent from systemd
SSH_SOCK="/run/user/$(id -u)/ssh-agent.socket"
if [ -S "$SSH_SOCK" ]; then
    export SSH_AUTH_SOCK=$SSH_SOCK
    export SSH_AGENT_PID=$(pgrep -f "ssh-agent.*${SSH_SOCK}")
else
    # Second, try loading the SSH agent from Gnome keyring daemon
    SSH_SOCK="/run/user/$(id -u)/gcr/ssh"
    if [ -S "$SSH_SOCK" ]; then
        export SSH_AUTH_SOCK=$SSH_SOCK
        export SSH_AGENT_PID="$(lsof -U | grep "/run/user/1000/gcr/ssh" | grep -v 'systemd' | cut -d' ' -f2)"
    fi
fi

# Function for adding Bitwarden SSH keys
function bwsshkeys {
    if [[ -z "${BW_SESSION}" ]]; then
        echo "No Bitwarden session key found"
    fi

    sshkeys=$(bw list items | jq -c '[ .[] | select(.fields[]?.name == "ssh-add") | {path: (.fields[] | select(.name == "ssh-add")).value, password: .login.password } ]')

    keypaths=($(echo $sshkeys | jq -r '[.[].path] | @sh' ))
    keypasswds=($(echo $sshkeys | jq -r '[.[].password] | @sh'))

    for index in $(seq 1 ${#keypaths[@]}); do
        keypasswd="${keypasswds[$index]%'}"
        keypasswd="${keypasswd#'}"

        keypath="${keypaths[$index]%'}"
        keypath="${keypath#'}"
        keypath="${keypath/#\~/$HOME}"

        env SSH_PASS=$keypasswd SSH_ASKPASS_REQUIRE=force SSH_ASKPASS=/usr/local/bin/auto-sshaskpass.sh ssh-add $keypath
    done
}

# XDG environment variables
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share
export XDG_STATE_HOME=${HOME}/.local/state

# Load other platform/distro specific zsh settings
if [ -f ~/.zsh/distro/init.zsh ]; then
    source ~/.zsh/distro/init.zsh
else
    echo "[!] Failed to find '~/.zsh/distro/init.zsh'"
fi

if [ -f ~/.zsh/platform/init.zsh ]; then
    source ~/.zsh/platform/init.zsh
else
    echo "[!] Failed to find '~/.zsh/platform/init.zsh'"
fi
