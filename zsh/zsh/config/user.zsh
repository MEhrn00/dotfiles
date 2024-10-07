typeset -U path

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

function djwt {
    if [[ -x $(command -v jq) ]]
    then
        if [ -t 0 ]
        then
            if [ -z "$1" ]
            then
                echo "Token not specified"
                return 1
            else
                token=$1
            fi
        else
            token=$(cat)
        fi
        echo -n "$token" | cut -d'.' -f1 | base64 -d -w0 2> /dev/null | jq
        echo -n "$token" | cut -d'.' -f2 | base64 -d -w0 2> /dev/null | jq
        true
    fi
}
