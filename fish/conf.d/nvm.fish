set -q NVM_DIR; or set -Ux NVM_DIR "$XDG_CONFIG_HOME/nvm"

function nvm
    bass source $NVM_DIR/nvm.sh --no-use ';' nvm $argv
end

if not set -q NVM_BIN
    nvm use default --silent
end
