# Custom ZSH functions

# Function for running ctags with ignore files
tgen() {
    # Make default excludes for ctags (only need .idea because everything is in gitignore)
    local excludes="--exclude=.git"

    # Add global gitignore to tagslist
    if [[ -f "$HOME/.config/git/ignore" ]]; then
        while IFS= read -r line; do
            excludes+=" --exclude=$line"
        done < "$HOME/.config/git/ignore"
    fi

    # Add local .gitignore if exists
    if [[ -f ".gitignore" ]]; then
        while IFS= read -r line; do
            excludes+=" --exclude=$line"
        done < ".gitignore"
    fi

    # Add .ctagsignore if exists
    if [[ -f ".ctagsignore" ]]; then
        while IFS= read -r line; do
            excludes+=" --exclude=$line"
        done < ".ctagsignore"
    fi

    if [[ "$1" == "-e" ]]; then
        ctags -e -R $(echo -n $excludes) .
    else
        ctags -R $(echo -n $excludes) .
    fi
}

