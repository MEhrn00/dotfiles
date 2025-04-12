function vi
    if test -n "$NVIM_REMOTE_SOCKET"
        nvim --server $NVIM_REMOTE_SOCKER --remote $argv
    else
        nvim $argv
    end
end
