### Real zsh init. Configures general settings and loads other settings

_zshdir="$(dirname $0)"

# Source settings
_settings=(${_zshdir}/settings/*.zsh)
for _setting in ${_settings[@]}; do
    source $_setting
done

# Load other platform/distro specific zsh settings
if [ -f ${_zshdir}/distro/init.zsh ]; then
    source ${_zshdir}/distro/init.zsh
else
    echo "[!] Failed to find '${_zshdir}/distro/init.zsh'"
fi

if [ -f ${_zshdir}/platform/init.zsh ]; then
    source ${_zshdir}/platform/init.zsh
else
    echo "[!] Failed to find '${_zshdir}/platform/init.zsh'"
fi
