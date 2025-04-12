set -q EDITOR; or set -Ux EDITOR nvim
set -q LESS; or set -Ux LESS -R
set -q PAGER; or set -Ux PAGER 'less -F'
set -q MANGPAGER; or set -Ux MANPAGER less
set -q GROFF_NO_SGR; or set -Ux GROFF_NO_SGR 1

set -q JAVA_HOME; or test -e /etc/alternatives/java_sdk_openjdk; and set -Ux JAVA_HOME /etc/alternatives/java_sdk_openjdk

set -q SSH_AUTH_SOCK; or set -Ux SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

set -q NVM_DIR; or set -Ux NVM_DIR "$XDG_CONFIG_HOME/nvm"

if status is-interactive
    if test -x /usr/local/bin/nvim; or test -x /usr/bin/nvim
        set -Ux MANPAGER 'nvim +Man!'
    end

    if tput colors 2>/dev/null | grep -q '256'
        set -Ux PAGER 'less -R --use-color -Du51 -Dd83 -DP4.7 -DE4.7 -DS4.7'
    end
end
