# Platform-specific zsh settings

# Platform detection routines
# - WSL
# - native


# Detect platform
if [[ "$(uname -r | tr '[:upper:]' '[:lower:]')" =~ wsl2?$ ]]; then
    _platform=wsl
else
    _platform=native
fi

# Source platform directory if it exists
if [ -d "${_zshdir}/platform/${_platform}" ]; then
    _platform_files=(${_zshdir}/platform/${_platform}/*.zsh)
    for _platform_file in ${_platform_files[@]}; do
        source $_platform_file
    done
fi
