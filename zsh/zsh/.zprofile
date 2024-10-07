[ -x /usr/bin/nvim ] && export EDITOR=/usr/bin/nvim

export JAVA_HOME=${JAVA_HOME:-/etc/alternatives/java_sdk_openjdk}
export GROFF_NO_SGR=1
export LESS=-r

export AWS_CONFIG_FILE=${AWS_CONFIG_FILE:-$XDG_CONFIG_HOME/aws/config}
export AWS_SHARED_CREDENTIALS_FILE=${AWS_SHARED_CREDENTIALS_FILE:-$XDG_CONFIG_HOME/aws/credentials}
export AWS_DATA_PATH=${AWS_DATA_PATH:-$XDG_CONFIG_HOME/aws/models}
export AWS_PAGER=${AWS_PAGER:-'less -F -X'}

export GOPATH=${GOPATH:-$XDG_DATA_HOME/go}

export BITWARDENCLI_APPDATA_DIR=${BITWARDENCLI_APPDATA_DIR:-$XDG_CONFIG_HOME/bitwarden}
export BWS_CONFIG_FILE=${BWS_CONFIG_FILE:-$XDG_CONFIG_HOME/bws/config}

export RUSTUP_HOME=${RUSTUP_HOME:-$XDG_CONFIG_HOME/rustup}
export CARGO_HOME=${CARGO_HOME:-$XDG_CONFIG_HOME/cargo}

if [ -z $VCPKG_ROOT ]; then
    if [ -d /usr/share/vcpkg ]; then
        export VCPKG_ROOT=/usr/share/vcpkg
    elif [ -d $XDG_DATA_HOME/vcpkg ]; then
        export VCPKG_ROOT=$XDG_DATA_HOME/vcpkg
    fi
fi

# TODO: pyenv + virtualenv
export PYENV_ROOT=$XDG_DATA_HOME/pyenv

if [ -S $XDG_RUNTIME_DIR/ssh-agent.socket ]; then
    export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
    export SSH_AGENT_PID=$(pgrep -f "ssh-agent.*$SSH_AUTH_SOCK")
elif [ -S $XDG_RUNTIME_DIR/gcr/ssh ]; then
    export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh
    export SSH_AGENT_PID=$(lsof -U | grep $SSH_AUTH_SOCK | grep -v systemd | cut -d' ' -f2)
fi

# Configure path
typeset -U path

path=(
    $path
    $HOME/.local/bin
    /usr/local/go/bin
    $GOPATH/bin
    $CARGO_HOME/bin
)

# WSL
if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
    path=(
        $path
        /mnt/c/Windows/System32
        /mnt/c/Windows/System32/WindowsPowerShell/v1.0
    )

    export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
    export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH=/mnt/c/Users/matth/
    export VAGRANT_DEFAULT_PROVIDER=hyperv
else
    export VAGRANT_DEFAULT_PROVIDER=libvirt
fi

