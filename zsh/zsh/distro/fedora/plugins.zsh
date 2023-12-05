SCRIPT=$(echo $PWD | sed -E "s|$HOME|~|g")

# FzF keybinds
test_source "/usr/share/fzf/shell/key-bindings.zsh" "Failed to load FzF keybinds"

# Autosuggestions
test_source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" "Failed to load Zsh autosuggestions"

# Syntax highlighting
test_source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "Failed to load Zsh syntax highlighting"

# Command not found handler (automatically loaded via '/etc/profile.d/PackageKit.sh')
#test_source "/etc/zsh_command_not_found" "Failed to load command not found handler"
