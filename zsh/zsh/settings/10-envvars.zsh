# ZSH environment variables

# Set the go path to a hidden dir
export GOPATH=$HOME/.go

# Set the GPG tty
export GPG_TTY=$(tty)

# Add colorful man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

# Color term
export COLORTERM=truecolor

# Add .local/bin and .go/bin to path
export PATH=$PATH:$HOME/.local/bin:$GOPATH/bin

# Add golang install to path
#export PATH=$PATH:/usr/local/go/bin

# AWS settings
export AWS_DEFAULT_PROFILE='mehrn00'
export AWS_PAGER='less -F -X'

# Set the Bitwarden CLI data directory
export BITWARDENCLI_APPDATA_DIR="${XDG_CONFIG_HOME}/bitwarden"

# Java
export JAVA_HOME=/etc/alternatives/java_sdk_openjdk
