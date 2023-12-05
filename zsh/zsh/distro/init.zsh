# Distro-specific zsh settings

# TODO: Display warning if distro settings directory is not found
# TODO: Add arch settings


# Helper function which sources a file if it exists or displays a warning
function test_source {
    SCRIPT=$([ ! -z "$SCRIPT" ] && echo "$SCRIPT" || echo $PWD | sed -E "s|$HOME|~|g")
    if [ -z "$1" ]; then
        echo "[!] (ERROR) $SCRIPT:$LINENO Source file not specified"
        return
    fi

    if [ -f $1 ]; then
        source $1
    else
        if [ ! -z "$2" ]; then
            echo "[*] $SCRIPT: " "$2"
        else
            echo "[*] $SCRIPT: Failed to source '$1'"
        fi
    fi
}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
elif type lsb_release >/dev/null 2>&1; then
    DISTRO=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
fi

ZSHFILES=($(find ${_zshdir}/distro/${DISTRO}/ -type f -name "*.zsh" 2>/dev/null | tr '\n' ' '))
for FILE in $ZSHFILES; do
    source $FILE
done
