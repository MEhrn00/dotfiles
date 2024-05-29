# FzF keybinds
if [ -f "/usr/share/doc/fzf/examples/key-bindings.zsh" ]; then
    source "/usr/share/doc/fzf/examples/key-bindings.zsh"
fi

# Autosuggestions
if [ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Syntax highlighting
if [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Command not found handler
if [ -f "/etc/zsh_command_not_found" ]; then
    source "/etc/zsh_command_not_found"
fi
