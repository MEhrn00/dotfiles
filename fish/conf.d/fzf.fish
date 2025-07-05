function source_fzf_keybinds
    set fzf_keybinds_paths /usr/share/doc/fzf/examples/key-bindings.fish /usr/share/fzf/shell/key-bindings.fish

    for val in $fzf_keybinds_paths
        if test -f $val
            source $val
            fzf_key_bindings
            return
        end
    end
end

if status is-interactive
    source_fzf_keybinds
end
