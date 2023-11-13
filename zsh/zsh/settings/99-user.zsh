# ZSH options which do not fit in a specific category

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

# Function for adding Bitwarden SSH keys
function bwsshkeys {
    if [[ -z "${BW_SESSION}" ]]; then
        echo "No Bitwarden session key found"
    fi

    sshkeys=$(bw list items | jq -c '[ .[] | select(.fields[]?.name == "ssh-add") | {path: (.fields[] | select(.name == "ssh-add")).value, password: .login.password } ]')

    keypaths=($(echo $sshkeys | jq -r '[.[].path] | @sh' ))
    keypasswds=($(echo $sshkeys | jq -r '[.[].password] | @sh'))

    for index in $(seq 1 ${#keypaths[@]}); do
        keypasswd="${keypasswds[$index]%'}"
        keypasswd="${keypasswd#'}"

        keypath="${keypaths[$index]%'}"
        keypath="${keypath#'}"
        keypath="${keypath/#\~/$HOME}"

        env SSH_PASS=$keypasswd SSH_ASKPASS_REQUIRE=force SSH_ASKPASS=/usr/local/bin/auto-sshaskpass.sh ssh-add $keypath
    done
}
