set -q EDITOR; or set -gx EDITOR nvim
set -q LESS; or set -Ux LESS -R
set -q PAGER; or set -Ux PAGER 'less -F'
set -q MANGPAGER; or set -gx MANPAGER less
set -q GROFF_NO_SGR; or set -Ux GROFF_NO_SGR 1

set -q JAVA_HOME; or test -e /etc/alternatives/java_sdk_openjdk; and set -gx JAVA_HOME /etc/alternatives/java_sdk_openjdk

set -q SSH_AUTH_SOCK; or set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

set -q NVM_DIR; or set -gx NVM_DIR "$XDG_CONFIG_HOME/nvm"

if status is-interactive
    if test -x /usr/local/bin/nvim; or test -x /usr/bin/nvim
        set -gx MANPAGER 'nvim +Man!'
    end

    if tput colors 2>/dev/null | grep -q '256'
        set -gx PAGER 'less -R --use-color -Du51 -Dd83 -DP4.7 -DE4.7 -DS4.7'
    end
end
