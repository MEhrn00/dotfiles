set -q RUSTUP_HOME; or set -Ux RUSTUP_HOME "$XDG_CONFIG_HOME/rustup"
set -q CARGO_HOME; or set -Ux CARGO_HOME "$XDG_CONFIG_HOME/cargo"

if test -d "$CARGO_HOME"
    fish_add_path "$CARGO_HOME/bin"
end
