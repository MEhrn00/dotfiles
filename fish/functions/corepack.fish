function corepack
    if not set -q NVM_CD_FLAGS
        nvm --version >/dev/null
    end

    if not set -q NVM_BIN
        nvm use node >/dev/null
    end

    $NVM_BIN/corepack $args
end
