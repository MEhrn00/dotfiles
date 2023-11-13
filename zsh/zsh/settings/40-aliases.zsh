# ZSH aliases

# Alias to run a new shell session with ASLR disabled
alias disable_aslr="setarch `uname -m` -R /bin/bash"

# Display colors with ls
alias ls="ls --color=auto"

# ls is hard
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

# Display colors with grep
alias grep="grep --color=auto"

# Emacs client
alias ec="emacsclient"

# pwninit with user template
alias pwninit="pwninit --template-path ${XDG_CONFIG_HOME}/nvim/snippets/pwninit-template.py --template-bin-name e"

# CTF flag
alias flag="printf 'flag{%s}' $(head /dev/urandom | md5sum | cut -d' ' -f1)"
