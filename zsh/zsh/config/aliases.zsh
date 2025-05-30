alias ls="ls --color=auto"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

alias k="kubectl"
alias grep="grep --color=auto"
alias ec="emacsclient"
alias neogit='nvim -c "Neogit kind=replace"'
alias t="tmux"

# In WSL
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ] || [ -f /proc/sys/fs/binfmt_misc/WSLInterop-late ]; then
    alias code='/mnt/c/Users/matth/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code'
    alias cmd.exe=/mnt/c/Windows/System32/cmd.exe
    alias cmd=/mnt/c/Windows/System32/cmd.exe
    alias open='wslview'
fi

alias soft="ssh gitserver"
