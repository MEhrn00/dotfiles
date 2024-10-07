__autosuggestions_paths=(
    /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
)

__syntax_highlighting_paths=(
    /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)

__command_not_found_paths=(
    /usr/share/doc/pkgfile/command-not-found.zsh
    /etc/zsh_command_not_found
)

__fzf_keybinds_paths=(
    /usr/share/doc/fzf/examples/key-bindings.zsh
    /usr/share/fzf/shell/key-bindings.zsh
)

for __plugin_path in "${__autosuggestions_paths[@]}"; do
    if [ -f $__plugin_path ]; then
        source $__plugin_path
        break
    fi
done

for __plugin_path in "${__syntax_highlighting_paths[@]}"; do
    if [ -f $__plugin_path ]; then
        source $__plugin_path
        break
    fi
done

for __plugin_path in "${__command_not_found_paths[@]}"; do
    if [ -f $__plugin_path ]; then
        source $__plugin_path
        break
    fi
done

for __plugin_path in "${__fzf_keybinds_paths[@]}"; do
    if [ -f $__plugin_path ]; then
        source $__plugin_path
        break
    fi
done
