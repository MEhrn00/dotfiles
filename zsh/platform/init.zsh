# Platform-specific zsh settings

# A "platform" is defined as a shell session running in a certain environment.
# An environment can be platform-based such as WSL or application based such as tmux.
# This will identify what platform the zsh session is running in and source the necessary
# settings


if [[ "$(uname -r | tr '[:upper:]' '[:lower:]')" =~ wsl2?$ ]]; then
    PLATFORM=wsl
else
    PLATFORM=native
fi

ZSHFILES=($(find ~/.zsh/platform/${PLATFORM}/ -type f -name "*.zsh" | tr '\n' ' '))
for FILE in $ZSHFILES; do
    source $FILE
done
