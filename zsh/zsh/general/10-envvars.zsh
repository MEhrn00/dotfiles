# ZSH environment variables

# Set truecolor terminal
export COLORTERM="truecolor"

# Add colorful man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

# Set the GPG tty
export GPG_TTY=$(tty)

# Add $HOME/.local/bin to $PATH
export PATH="$PATH:$HOME/.local/bin"

# Set editor
if command -v nvim &> /dev/null; then
    export EDITOR=$(which nvim)
elif command -v vim &> /dev/null; then
    export EDITOR=$(which vim)
fi

# Configure Golang environment variables if Golang is installed
if [ -d "/usr/local/go" ] && [ -x "/usr/local/go/bin/go" ]; then
    export PATH="$PATH:/usr/local/go/bin"
    export GOPATH="$HOME/.local/go"
    export PATH="$PATH:$GOPATH/bin"
fi

# Use "$XDG_CONFIG_HOME" for AWS CLI
if command -v aws &> /dev/null; then
    export AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
    export AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"
    export AWS_DATA_PATH="${XDG_CONFIG_HOME}/aws/models"
    export AWS_PAGER='less -F -X'
fi

# Use "$XDG_CONFIG_HOME" for Bitwarden CLI
if command -v bws &> /dev/null; then
    export BITWARDENCLI_APPDATA_DIR="${XDG_CONFIG_HOME}/bitwarden"
    export BWS_CONFIG_FILE="${XDG_CONFIG_HOME}/bws/config"
fi

# Set DOCKER_HOST if podman is present and docker is not present
if command -v podman &> /dev/null && ! command -v docker &> /dev/null; then
    # Use $XDG_RUNTIME_DIR because 'podman info -f' has a load cost
    export DOCKER_HOST="unix://${XDG_RUNTIME_DIR%/}/podman/podman.sock"
fi

# Set VCPKG_ROOT
if [ -z "$VCPKG_ROOT" ]; then
    if [ -d /usr/share/vcpkg ]; then
        export VCPKG_ROOT=/usr/share/vcpkg
    elif [ -d "${XDG_DATA_HOME}/vcpkg" ]; then
        export VCPKG_ROOT="${XDG_DATA_HOME}/vcpkg"
    fi
fi
