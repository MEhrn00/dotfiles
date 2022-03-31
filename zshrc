# Zsh things
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep

# Share history between sessions
setopt share_history

# Set key timeout
KEYTIMEOUT=1

# Set the dircolors if the file exists
if [ -f ~/.dircolors ]; then
    eval "$(dircolors ~/.dircolors)"
fi

# Set up completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
bindkey '^[[Z' reverse-menu-complete

# Prompt customization
autoload -Uz promptinit
promptinit

## Git prompt status
autoload -Uz vcs_info
setopt promptsubst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ":U"
zstyle ':vcs_info:git:*' formats "(%s)-[%b%u]%c"

RETURN_CODE="%(?..%{%F{red}%}%? )%{%F{white}%}"
draw_prompt() {
    vcs_info
    PROMPT=""
    if [[ "$VIRTUAL_ENV" != '' ]]
    then
        PROMPT+="(%{%F{red}%}`basename $VIRTUAL_ENV`%{%F{white}%}) "
    fi

    PROMPT+="%{%F{green}%}%n@%m%{%F{white}%} :: %{%F{blue}%}%~%{%F{white}%} "

    if [[ "${vcs_info_msg_0_}" != '' ]]
    then
        PROMPT+='%{%F{yellow}%}${vcs_info_msg_0_}%{%F{white}%} '
    else
        PROMPT+=''
    fi

    PROMPT+="$RETURN_CODE>> "
}

alacritty_pwd() {
    case ${TERM} in
      xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
         PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "$(</etc/hostname)" "${PWD/#$HOME/~}"'

        ;;
      screen*)
        PROMPT_COMMAND='printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
        ;;
    esac
    eval "$PROMPT_COMMAND"
}

#precmd_functions+=(precmd_vcs_info)
precmd_functions+=(draw_prompt)
precmd_functions+=(alacritty_pwd)

# Alias to disable aslr in a new session since setting /proc/sys/kernel/randomize_va_space
# for system wide aslr is a terrible practice
alias disable_aslr="setarch `uname -m` -R /bin/bash"

# Alias to make it more bash-like
alias ls="ls --color=auto"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias grep="grep --color=auto"


# Set xclip to copy to system clipboard by default
alias xclip="xclip -selection clipboard"

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

# pwninit using my template (needs my fork of pwninit using handlebars templating)
alias pwninit="pwninit --template-path ~/.config/nvim/snippets/pwninit-template.py --template-bin-name e"

# Set go path to a hidden dir
export GOPATH=$HOME/.go

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

# Zsh history substring search plugin `pacman -S zsh-history-substring-search`
if [ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
else
    echo "[*] Zsh history substring search not found"
fi

# Zsh autosuggestions `pacman -S zsh-autosuggestions`
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    echo "[*] Zsh autosuggestions not found"
fi

# Zsh syntax highlighting `pacman -S zsh-syntax-highlighting`
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
else
    echo "[*] Zsh syntax highlighting not found"
fi

# Command not found handler `pacman -S pkgfile && pkgfile -u`
if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
else
    echo "[*] Command not found handler not found"
fi

eval "$(pyenv init -)"
