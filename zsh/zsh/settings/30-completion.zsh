# ZSH Completion settings

# Load compinit and complist
autoload -Uz compinit
compinit
zmodload zsh/complist

# Enable _extensions, _complete and _approximate
zstyle ':completion:*' completer _extensions _complete _approximate

# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Display completion selection and allow dynamic selecting of completion option
zstyle ':completion:*' menu select

# Display completitions with ambiguity
zstyle ':completion:*' list-suffixes

# Expand strings when completing
#zstyle ':completion:*' expand prefix suffix

# Set completion colors to default to ls colors
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Set the completion matcher-list to first try case-insensitive matches and then do
# partial matches
#zstyle ':completion:*' matcher-list 'm:{a-z-}={A-Z_}'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Add default completion description format
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'

# Add default completion corrections format
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'

# Add completion messages
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'

# Add completion warnings
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Group completion menu
zstyle ':completion:*' group-name ''

# Group order
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands

# File completion extended info
zstyle ':completion:*' file-list list=20 insert=10

# Split up files and directories in group
zstyle ':completion:*' file-patterns '%p(^-/):globbed-files *(-/):directories:directory'

# Dedup slashes
zstyle ':completion:*' squeeze-slashes true

# Add directory stack completion
zstyle ':completion:*' complete-options true

# Cancel completion using <C-u>
bindkey -M menuselect '^u' send-break

# Set shift+tab to do cycle through the completion list in reverse
bindkey '^[[Z' reverse-menu-complete

# SSH remove useless host and ip entries
zstyle ':completion:*:*:(ssh|scp|sftp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' 'loopback' 'ip6-loopback' 'localhost' 'ip6-localhost' 'broadcasthost'
zstyle ':completion:*:*:(ssh|sftp|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Change the host tag names
zstyle ':completion:*:(ssh|scp|sftp|rsync):*:users' format '%F{green}-- users --%f'
zstyle ':completion:*:(ssh|scp|sftp|rsync):*:hosts' format '%F{green}-- hosts --%f'

_h=()
if [[ -r "${HOME}/.ssh/config" ]]; then
    _h=($_h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})

    if [[ -r "${HOME}/.ssh/config.d" ]]; then
        _h=($_h ${${${(@M)${(f)"$(cat ~/.ssh/config.d/*)"}:#Host *}#Host }:#*[*?]*})
    fi
fi

# Set list of SSH hosts
zstyle ':completion:*:*:(ssh|scp|sftp|rsync):*' hosts $_h


_u=()
if [[ -r "${HOME}/.ssh/config" ]]; then
fi

# Add make command completion for make targets and variables
zstyle ':completion::complete:make::' tag-order 'targets variables'

# Add kubectl completions
source <(kubectl completion zsh)
