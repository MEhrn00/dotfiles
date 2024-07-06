# User defined ZSH settings

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Set up shared SSH agent
SSH_SOCK="/run/user/$(id -u)/ssh-agent.socket"
if [ -S "$SSH_SOCK" ]; then
    export SSH_AUTH_SOCK=$SSH_SOCK
    export SSH_AGENT_PID=$(pgrep -f "ssh-agent.*${SSH_SOCK}")
else
    # Second, try loading the SSH agent from Gnome keyring daemon
    SSH_SOCK="/run/user/$(id -u)/gcr/ssh"
    if [ -S "$SSH_SOCK" ]; then
        export SSH_AUTH_SOCK=$SSH_SOCK
        export SSH_AGENT_PID="$(lsof -U | grep "/run/user/1000/gcr/ssh" | grep -v 'systemd' | cut -d' ' -f2)"
    fi
fi

# Function for running ctags with a derived list of excludes
function tgen {
    # Default list of ctags excludes
    local defaultCtagsExcludes=(
        ".git"          # Git metadata
        "target"        # Rust target
        "Cargo.lock"    # Rust crate pins
        "go.mod"        # Golang module info
        "go.sum"        # Golang module pins
    )

    # Add global gitignore file to excludes list
    local globalGitIgnore=()
    local globalGitIgnoreFilePath=""
    if [[ -f "${HOME}/.gitconfig" ]]; then
        globalGitIgnoreFilePath=$(grep "excludesFile" ~/.gitconfig | awk '{ print $NF }')
        globalGitIgnore=($(grep -v "^#" "${globalGitIgnoreFilePath}"))
    fi

    # Add local .gitignore files to the excludes list
    local localGitIgnore=()
    if [[ -f ".gitignore" ]]; then
        localGitIgnore=($(grep -v "^#" ".gitignore"))
    fi

    # Add .ctagsignore files to the excludes list
    local ctagsIgnore=()
    if [[ -f ".ctagsignore" ]]; then
        ctagsIgnore=($(grep -v "^#" ".ctagsignore"))
    fi

    # Create the list of ctags excludes
    local ctagsExcludes=(
        ${defaultCtagsExcludes[@]}
        ${globalGitIgnore[@]}
        ${localGitIgnore[@]}
        ${ctagsIgnore[@]}
    )

    # Formulate the ctags excludes argument string
    local ctagsExcludesArguments=$(printf '--exclude="%s" ' "${ctagsExcludes[@]}")

    # Check if '--list' or '--dry-run' were passed in as an argument
    if [[ "$1" == "--list" ]]; then
        echo "# Default excludes"
        printf "%s\n" "${defaultCtagsExcludes[@]}"

        if [[ ! -z "${globalGitIgnore[@]}" ]]; then
            echo "\n# Excludes list from '${globalGitIgnoreFilePath}'"
            printf "%s\n" "${globalGitIgnore[@]}"
        fi

        if [[ ! -z "${localGitIgnore[@]}" ]]; then
            echo "\n# Excludes list from '.gitignore'"
            printf "%s\n" "${localGitIgnore[@]}"
        fi

        if [[ ! -z "${ctagsIgnore[@]}" ]]; then
            echo "\n# Excludes list from '.ctagsignore'"
            printf "%s\n" "${ctagsIgnore[@]}"
        fi
    elif [[ "$1" == "--dry-run" ]]; then
        echo "ctags -R $ctagsExcludesArguments ."
    else
        ctags -R $ctagsExcludesArguments .
    fi
}
