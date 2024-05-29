# Distro-specific zsh settings


if [ -f /etc/os-release ]; then
    . /etc/os-release
    _distro=$ID
elif type lsb_release >/dev/null 2>&1; then
    _distro=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
fi

# Source distro directory if it exists
if [ -d "${_zshdir}/distro/${_distro}" ]; then
    _distro_files=(${_zshdir}/distro/${_distro}/*.zsh)
    for _distro_file in ${_distro_files[@]}; do
        source $_distro_file
    done
fi
