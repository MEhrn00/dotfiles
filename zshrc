# Zsh things
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep

# Start completion
autoload -Uz compinit
compinit

# Share history between sessions
setopt share_history

# Set key timeout
KEYTIMEOUT=1

# Set the dircolors (removes sticky directory highlighting for wsl)
if [ -f ~/.dircolors ]; then
    eval "$(dircolors ~/.dircolors)"
else
    echo "[*] Dircolors file not found (dircolors -p > ~/.dircolors)"
fi

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

# Alias to disable aslr in a new session since setting /proc/sys/kernel/randomize_va_space
# for system wide aslr is a terrible practice
alias disable_aslr="setarch `uname -m` -R /bin/bash"

# Alias to make it more bash-like
alias ls="ls --color=auto"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias grep="grep --color=auto"

# Make xclip more like pbcopy on mac
alias xclip="xclip -selection clipboard"

# Zsh function containing common excludes for ctags and to parse .git and .ctagsignore
# files for excludes list
tgen() {
    # Make default excludes for ctags (only need .idea because everything is in gitignore)
    local excludes="--exclude=.idea --exclude=.git"

    # Add global gitignore to tagslist (need to change this eventually because ctags
    # doesn't support wildcards and gitignore does)
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

    ctags -R `echo -n $excludes` .
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

# Open new tab in CWD (old gnome terminal thing)
if [ -f /etc/profile.d/vte.sh ]; then
    source /etc/profile.d/vte.sh
fi

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
