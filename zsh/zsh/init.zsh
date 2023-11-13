### Real zsh init. Configures general settings and loads other settings

_zshdir="$(dirname $0)"

# Source settings
_settings=(${_zshdir}/settings/*.zsh)
for _setting in ${_settings[@]}; do
    source $_setting
done

# Load other platform/distro specific zsh settings
if [ -f ~/.zsh/distro/init.zsh ]; then
    source ~/.zsh/distro/init.zsh
else
    echo "[!] Failed to find '~/.zsh/distro/init.zsh'"
fi

if [ -f ~/.zsh/platform/init.zsh ]; then
    source ~/.zsh/platform/init.zsh
else
    echo "[!] Failed to find '~/.zsh/platform/init.zsh'"
fi
