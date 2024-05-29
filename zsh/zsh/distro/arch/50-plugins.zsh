# TODO: Add FzF keybinds

# Autosuggestions
if [ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Syntax highlighting
if [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Command not found handler
if [ -f "/usr/share/doc/pkgfile/command-not-found.zsh" ]; then
    source "/usr/share/doc/pkgfile/command-not-found.zsh"
fi
