# Load promptinit for prompt customization
autoload -Uz promptinit && promptinit

# Load prompt colors
autoload -U colors && colors

# Define common prompt color strings
color_red="%{%F{red}%}"
color_white="%{%F{white}%}"
color_blue="%{%F{blue}%}"
color_green="%{%F{green}%}"
color_yellow="%{%F{yellow}%}"
color_reset="%{$reset_color%}"

# Load vcs info
autoload -Uz vcs_info
setopt promptsubst
zstyle ':vcs_info:git:*' check-for-staged-changes true
zstyle ':vcs_info:git:*' formats "${color_yellow}(%s)-[%b]%u%c"
zstyle ':vcs_info:git:*' actionformats "${color_yellow}(%s)-[%b]%u%c-[%a]"
zstyle ':vcs_info:hg:*' formats "${color_yellow}(%s)-[%b]%u%c"

# Set the python virtualenv prompt item
virtualenv_info() {
    if [ -n "$VIRTUAL_ENV" ]; then
        virtualenv_info_msg="(${color_red}`basename $VIRTUAL_ENV`${color_reset})"
    else
        virtualenv_info_msg=''
    fi
}

# Set the user context prompt item
usercontext_info_msg="${color_green}%n@%m"

# Variable holding the prompt path style option
currentpath_info_opt=long

# Function for toggling the prompt path style
toggle_currentpath_info_opt() {
    if [ "$currentpath_info_opt" = short ]; then
        currentpath_info_opt=long
    else
        currentpath_info_opt=short
    fi

    # Redraw the prompt
    draw_prompt
    zle reset-prompt
}

# Register the prompt style as a zsh function
zle -N toggle_currentpath_info_opt

# Bind <C-o> to change the prompt style
bindkey "\C-o" toggle_currentpath_info_opt

# Set the current path prompt item
currentpath_info() {
    if [ "$currentpath_info_opt" = long ]; then
        # Display the full current directory with '~' signifying the user home directory
        currentpath_info_msg="${color_blue}%~"
    else
        # Shorten the current working directory to the first letter of the directory
        currentpath_info_msg="${color_blue}$(echo $PWD | sed -E "s|$HOME|~|g" | sed -E 's/(\w)[^\/]+\//\1\//g')"
    fi
}

lastreturncode_info_msg="%(?..${color_red}[%?] )"

draw_prompt() {
    virtualenv_info
    currentpath_info
    vcs_info

    local prompt_components=(
        "$virtualenv_info_msg"
        "$usercontext_info_msg"
        "::"
        "$currentpath_info_msg"
        "$vcs_info_msg_0_"
        "$lastreturncode_info_msg${color_reset}>>"
    )

    PROMPT=''
    for component in "${prompt_components[@]}"; do
        if [ -n "$component" ]; then
            PROMPT+="${component}${color_reset} "
        fi
    done
}

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
