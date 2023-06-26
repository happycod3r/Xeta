
zle-test-widget() {
    
    # For definitions and a list of all widgets available for use check 
    # out the documentation @ https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html

    # Available variables within a widget.
    
    # BUFFER (scalar)
    # BUFFERLINES (integer)
    # CONTEXT (scalar) [start|cont|select|vared]
    # CURSOR (integer)
    # CUTBUFFER (scalar)
    # HISTNO (integer)
    # ISEARCHMATCH_ACTIVE (integer)
    # ISEARCHMATCH_START (integer)
    # ISEARCHMATCH_END (integer)
    # KEYMAP (scalar)
    # KEYS (scalar)
    # KEYS_QUEUED_COUNT (integer)
    # killring (array)
    # LASTABORTEDSEARCH (scalar)
    # LASTSEARCH (scalar)
    # LASTWIDGET (scalar)
    # LBUFFER (scalar)
    # MARK (integer)
    # NUMERIC (integer)
    # PENDING (integer)
    # PREBUFFER (scalar)
    # PREDISPLAY (scalar)
    # POSTDISPLAY (scalar)
    # RBUFFER (scalar)
    # REGION_ACTIVE (integer)
    # region_highlight (array)
    # registers (associative array)
    # SUFFIX_ACTIVE (integer)
    # SUFFIX_START (integer)
    # SUFFIX_END (integer)
    # UNDO_CHANGE_NO (integer)
    # UNDO_LIMIT_NO (integer)
    # WIDGET (scalar)
    # WIDGETFUNC (scalar)
    # WIDGETSTYLE (scalar)
    # YANK_ACTIVE (integer)
    # YANK_START (integer)
    # YANK_END (integer)
    # ZLE_RECURSIVE (integer) (read-only)
    # ZLE_STATE (scalar)
}

autoload -U zle-test-widget
zle -N zle-test-widget
bindkey "${key_seqs[alt_x]}" zle-test-widget
