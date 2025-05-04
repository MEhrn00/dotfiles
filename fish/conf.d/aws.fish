set -q AWS_CONFIG_FILE; or set -gx AWS_CONFIG_FILE "$XDG_CONFIG_HOME/aws/config"
set -q AWS_SHARED_CREDENTIALS_FILE; or set -gx AWS_SHARED_CREDENTIALS_FILE "$XDG_CONFIG_HOME/aws/credentials"
set -q AWS_DATA_PATH; or set -gx AWS_DATA_PATH "$XDG_CONFIG_HOME/aws/models"
set -q AWS_PAGER; or set -gx AWS_PAGER "less -F -X"
