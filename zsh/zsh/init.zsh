### Real zsh init. Configures general settings and loads other settings

_zshdir="$(dirname $0)"

# Source general zsh configuration
_general=(${_zshdir}/general/*.zsh)
for _general in ${_general[@]}; do
    source $_general
done

# Load platform specific zsh settings
if [ -f ${_zshdir}/platform/init.zsh ]; then
    source ${_zshdir}/platform/init.zsh
else
    echo "[!] Failed to find '${_zshdir}/platform/init.zsh'"
fi

# Load other distro specific zsh settings
if [ -f ${_zshdir}/distro/init.zsh ]; then
    source ${_zshdir}/distro/init.zsh
else
    echo "[!] Failed to find '${_zshdir}/distro/init.zsh'"
fi
