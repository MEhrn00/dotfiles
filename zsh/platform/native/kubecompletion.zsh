# Add kubectl completions
# This has to be platform-specifc outside of WSL because completions have trouble loading
# when sharing with Windows
source <(kubectl completion zsh)
