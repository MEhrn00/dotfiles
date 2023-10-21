SCRIPT=$(echo $PWD | sed -E "s|$HOME|~|g")

# TODO: Add FzF keybinds

# Autosuggestions
test_source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" "Failed to load Zsh autosuggestions"

# Syntax highlighting
test_source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "Failed to load Zsh syntax highlighting"

# Command not found handler
test_source "/usr/share/doc/pkgfile/command-not-found.zsh" "Failed to load command not found handler"