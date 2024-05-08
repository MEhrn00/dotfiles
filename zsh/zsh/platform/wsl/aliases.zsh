# Open the Windows version of VS Code
alias code='/mnt/c/Users/matth/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code'

# Share gpg keys with Windows
#alias gpg='/mnt/c/Program\ Files\ \(x86\)/gnupg/bin/gpg.exe'

# Share podman with Windows
alias winpodman='/mnt/c/Program\ Files/RedHat/Podman//podman.exe'

# Share ssh-agent with Windows
#alias ssh=/mnt/c/WINDOWS/System32/OpenSSH//ssh.exe
#alias ssh-add=/mnt/c/WINDOWS/System32/OpenSSH//ssh-add.exe

alias cmd.exe=/mnt/c/Windows/System32/cmd.exe
alias cmd=/mnt/c/Windows/System32/cmd.exe

# Firefox
alias firefox='/mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe'

# xdg open
alias xdg-open='wslview'

# Function to display desktop notifications
function wsl-notify-send {
    /mnt/c/Users/matth/.local/bin/wsl-notify-send.exe --category $WSL_DISTRO_NAME "${@}";
}

# Vagrant WSL setup
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/Users/matth/"
export VAGRANT_DEFAULT_PROVIDER="hyperv"
