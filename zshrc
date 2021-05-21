# Zsh things
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep

# Start completion
autoload -Uz compinit
compinit

# Share history
setopt share_history

# Set key timeout
KEYTIMEOUT=1

# Set the dircolors
eval "$(dircolors ~/.dircolors)"

# Set up completion
zstyle ':completion:*' menu select
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
bindkey '^[[Z' reverse-menu-complete

# Prompt customization
autoload -Uz promptinit
promptinit

RETURN_CODE="%(?..%{%F{red}%}%? )%{%F{white}%}"
PROMPT="%{%F{green}%}%n@%m%{%F{white}%} :: %{%F{blue}%}%~%{%F{white}%} $RETURN_CODE>> "

# Set terminal title
autoload -Uz add-zsh-hook

function xterm_title_precmd () {
    print -Pn -- '\e]2;%n@%m %~\a'
    [[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
    print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
    [[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (Eterm*|alacritty*|aterm*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
    add-zsh-hook -Uz precmd xterm_title_precmd
    add-zsh-hook -Uz preexec xterm_title_preexec
fi


# Alias to disable aslr in a new session
alias disable_aslr="setarch `uname -m` -R /bin/bash"

# Alias to make it more ubuntu like
alias ls="ls --color=auto"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias grep="grep --color=auto"

# Clipboard
alias xclip="xclip -selection clipboard"

# Ctags
alias ctags="ctags --exclude=target --exclude=env --exclude=.vscode"

# pwninit
alias pwninit="pwninit --template-path ~/.config/nvim/snippets/pwninit-template.py --template-bin-name e"

# Set go path
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

# Plugins
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source /usr/share/doc/pkgfile/command-not-found.zsh

hex() {
    emulate -L zsh
    if [[ -n "$1" ]]; then
        printf "%x\n" $1
    else
        print 'Usage: hex <number-to-convert>'
        return 1
    fi
}

dec() {
    emulate -L zsh
    if [[ -n "$1" ]]; then
        printf "%d\n" $1
    else
        print 'Usage: dec <number-to-convert>'
        return 1
    fi
}
