# ZSH environment variables

# Set the go path to a hidden dir
export GOPATH=$HOME/.go

# Set the GPG tty
export GPG_TTY=$(tty)

# Add colorful man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

# Color term
export COLORTERM=truecolor

# Add .local/bin and .go/bin to path
export PATH=$PATH:$HOME/.local/bin:$GOPATH/bin

# Add golang install to path
export PATH=$PATH:/usr/local/go/bin

# AWS settings
export AWS_DEFAULT_PROFILE='mehrn00'
export AWS_PAGER='less -F -X'

# Set the Bitwarden CLI data directory
export BITWARDENCLI_APPDATA_DIR="${XDG_CONFIG_HOME}/bitwarden"

# Set the Bitwarden Secrets Manager CLI config path
export BWS_CONFIG_FILE="${XDG_CONFIG_HOME}/bws/config"

# DOCKER_HOST if podman is present but docker is not
if command -v podman &> /dev/null && ! command -v docker &> /dev/null; then
    # Use $XDG_RUNTIME_DIR because 'podman info -f' has a performance cost
    export DOCKER_HOST="unix://${XDG_RUNTIME_DIR%/}/podman/podman.sock"
fi

if command -v nvim &> /dev/null; then
    export EDITOR=$(which nvim)
elif command -v vim &> /dev/null; then
    export EDITOR=$(which vim)
fi
