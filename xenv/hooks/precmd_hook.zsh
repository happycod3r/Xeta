

# Called before each prompt.
precmd() {
    # - Set prompt here:
    echo "-------------| $(date)"
    
    # - Capture the previous command that was entered from history and store it to use.
    local previous_command
    previous_command=$(history -1)
    echo "Previous command: $previous_command"
}
