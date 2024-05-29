# ZSH prompt options

# Load prompt customization plugin
autoload -Uz promptinit
promptinit

# Add the git status in the prompt
autoload -Uz vcs_info
setopt promptsubst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ":U"
zstyle ':vcs_info:git:*' formats "(%s)-[%b%u]%c"


# Variable holding the prompt style
PROMPT_STYLE=long

# Function to toggle the prompt style to the next style
toggle_prompt_style() {
    if [ "$PROMPT_STYLE" = short ]; then
        PROMPT_STYLE=long
    else
        PROMPT_STYLE=short
    fi

    # Redraw the prompt if the style was changed
    draw_prompt
    zle reset-prompt
}

# Register the prompt style as a zsh function
zle -N toggle_prompt_style

# Bind <C-o> to change the prompt style
bindkey "\C-o" toggle_prompt_style

# Define common color strings
color_red="%{%F{red}%}"
color_white="%{%F{white}%}"
color_blue="%{%F{blue}%}"
color_green="%{%F{green}%}"
color_yellow="%{%F{yellow}%}"

# Variable holding the return code of the previous command
RETURN_CODE="%(?..${color_red}%? )${color_white}"

# Function which draw the prompt
draw_prompt() {
    # Grab the current git information
    vcs_info

    # Start the prompt definition
    PROMPT=""

    # Check if a python virtual environment is set and add it to the prompt
    if [[ "$VIRTUAL_ENV" != '' ]]
    then
        PROMPT+="(${color_red}`basename $VIRTUAL_ENV`${color_white}) "
    fi

    # Start the path portion of the prompt by making the color blue
    PROMPT_PATH="${color_blue}"

    # Check if the prompt option should be short or long
    if [ "$PROMPT_STYLE" = long ]; then
        # Display the full current directory with '~' signifying the user home directory
        PROMPT_PATH+="%~"
    else
        # Shorten the current working directory to the first letter of the directory
        PROMPT_PATH+="$(echo $PWD | sed -E "s|$HOME|~|g" | sed -E 's/(\w)[^\/]+\//\1\//g')"
    fi

    # Set the prompt color back to white
    PROMPT_PATH+="${color_white}"

    # Set the prompt to 'user@hostname :: cwd'
    PROMPT+="${color_green}%n@%m${color_white} :: $PROMPT_PATH "

    # Check if currently in a directory with version control
    if [[ "${vcs_info_msg_0_}" != '' ]]
    then
        # Add the version control info to the prompt
        PROMPT+="${color_yellow}${vcs_info_msg_0_}${color_white} "
    else
        PROMPT+=''
    fi

    # Add the previous command's return code to the prompt
    PROMPT+="$RETURN_CODE>> "
}

# Register the `draw_prompt` to execute during a command invocation
precmd_functions+=(draw_prompt)

# TODO: preexec_function which sets the terminal/tmux title to long running commands and then
# switches the title back to the regular prompt when finished. This setting will depend on
# what `TERM` is set, if there is a tmux session and whether or not in WSL.
tmux_set_window_title() {
    if [[ "${TMUX}" ]]; then
        cmd=$(echo "$1" | sed 's/\(.\{25\}\).*/\1.../')
        printf "\033k%s\033\\" "$cmd"
    fi
}

tmux_restore_window_title() {
    if [[ "${TMUX}" ]]; then
        cmd=$(ps -ho comm $$)
        printf "\033k%s\033\\" "$cmd"
    fi
}
preexec_functions+=(tmux_set_window_title)
precmd_functions+=(tmux_restore_window_title)
