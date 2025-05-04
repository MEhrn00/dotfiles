set -q GOPATH; or set -gx GOPATH "$XDG_DATA_HOME/go"

if test -d "$GOPATH/bin"
    fish_add_path "$GOPATH/bin"
end
