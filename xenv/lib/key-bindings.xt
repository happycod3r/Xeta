# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

typeset -gA key_seqs=(
    [up_arrow]='^[[A'           # Up arrow
    [down_arrow]='^[[B'         # Down arrow
    [right_arrow]='^[[C'        # Right arrow
    [left_arrow]='^[[D'         # Left arrow
    [f1]='^[[11~'               # F1
    [f2]='^[[12~'               # F2
    [f3]='^[[13~'               # F3
    [f4]='^[[14~'               # F4
    [f5]='^[[15~'               # F5
    [f6]='^[[16~'               # F6
    [f7]='^[[17~'               # F7
    [f8]='^[[18~'               # F8
    [f9]='^[[19~'               # F9
    [f10]='^[[20~'              # F10
    [f11]='^[[21~'              # F11
    [f12]='^[[22~'              # F12
    [home]='^[[H'               # Home
    [end]='^[[F'                # End
    [page_up]='^[[5~'           # Page up
    [page_down]='^[[6~'         # Page down
    [insert]='^[[2~'            # Insert
    [delete]='^[[3~'            # Delete
    [backspace]='^?'            # Backspace
    [tab]='^[[Z' # alt '^I'     # Tab
    [enter]='^M' # alt '^J'     # Enter
    [escape]='^['               # Escape
    [ctrl_a]='^A'               # Control + A
    [ctrl_b]='^B'               # Control + B
    [ctrl_c]='^C'               # Control + C
    [ctrl_d]='^D'               # Control + D
    [ctrl_e]='^E'               # Control + E
    [ctrl_f]='^F'               # Control + F
    [ctrl_g]='^G'               # Control + G
    [ctrl_h]='^H'               # Control + H
    [ctrl_i]='^I'               # Control + I
    [ctrl_j]='^J'               # Control + J
    [ctrl_k]='^K'               # Control + K
    [ctrl_l]='^L'               # Control + L
    [ctrl_m]='^M'               # Control + M 
    [ctrl_n]='^N'               # Control + N
    [ctrl_o]='^O'               # Control + O
    [ctrl_p]='^P'               # Control + P
    [ctrl_q]='^Q'               # Control + Q
    [ctrl_r]='^R'               # Control + R
    [ctrl_s]='^S'               # Control + S
    [ctrl_t]='^T'               # Control + T
    [ctrl_u]='^U'               # Control + U
    [ctrl_v]='^V'               # Control + V
    [ctrl_w]='^W'               # Control + W
    [ctrl_x]='^X'               # Control + X
    [ctrl_y]='^Y'               # Control + Y
    [ctrl_z]='^Z'               # Control + Z
    [ctrl_plus]='^\\'           # Control +
    [ctrl_closing_bracket]='^]' # Control + ]
    [ctrl_carot]='^^'           # Control + ^
    [ctrl_underscore]='^_'      # Control + _
    [alt_a]='^[a'               # Alt + A
    [alt_b]='^[b'               # Alt + B
    [alt_c]='^[c'               # Alt + C
    [alt_d]='^[d'               # Alt + D
    [alt_e]='^[e'               # Alt + E
    [alt_f]='^[f'               # Alt + F
    [alt_g]='^[g'               # Alt + G
    [alt_h]='^[h'               # Alt + H
    [alt_i]='^[i'               # Alt + I
    [alt_j]='^[j'               # Alt + J
    [alt_k]='^[k'               # Alt + K
    [alt_l]='^[l'               # Alt + L
    [alt_m]='^[m'               # Alt + M
    [alt_n]='^[n'               # Alt + N
    [alt_o]='^[o'               # Alt + O
    [alt_p]='^[p'               # Alt + P
    [alt_q]='^[q'               # Alt + Q
    [alt_r]='^[r'               # Alt + R
    [alt_s]='^[s'               # Alt + S
    [alt_t]='^[t'               # Alt + T
    [alt_u]='^[u'               # Alt + U
    [alt_v]='^[v'               # Alt + V
    [alt_w]='^[w'               # Alt + W
    [alt_x]='^[x'               # Alt + X
    [alt_y]='^[y'               # Alt + Y
    [alt_z]='^[z'               # Alt + Z
)

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Use emacs key bindings
bindkey -e

# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then
  bindkey -M emacs "${terminfo[kpp]}" up-line-or-history
  bindkey -M viins "${terminfo[kpp]}" up-line-or-history
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi
# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then
  bindkey -M emacs "${terminfo[knp]}" down-line-or-history
  bindkey -M viins "${terminfo[knp]}" down-line-or-history
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M emacs "${terminfo[khome]}" beginning-of-line
  bindkey -M viins "${terminfo[khome]}" beginning-of-line
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M emacs "${terminfo[kend]}"  end-of-line
  bindkey -M viins "${terminfo[kend]}"  end-of-line
  bindkey -M vicmd "${terminfo[kend]}"  end-of-line
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Backspace] - delete backward
bindkey -M emacs '^?' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char
# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey -M emacs "${terminfo[kdch1]}" delete-char
  bindkey -M viins "${terminfo[kdch1]}" delete-char
  bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
  bindkey -M emacs "^[[3~" delete-char
  bindkey -M viins "^[[3~" delete-char
  bindkey -M vicmd "^[[3~" delete-char

  bindkey -M emacs "^[3;5~" delete-char
  bindkey -M viins "^[3;5~" delete-char
  bindkey -M vicmd "^[3;5~" delete-char
fi

# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word
bindkey -M viins '^[[3;5~' kill-word
bindkey -M vicmd '^[[3;5~' kill-word

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word


bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
bindkey -s '\el' 'ls\n'                               # [Esc-l] - run command: ls
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
bindkey ' ' magic-space                               # [Space] - don't do history expansion


# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# file rename magick
bindkey "^[m" copy-prev-shell-word

# consider emacs keybindings:

#bindkey -e  ## emacs key bindings
#
#bindkey '^[[A' up-line-or-search
#bindkey '^[[B' down-line-or-search
#bindkey '^[^[[C' emacs-forward-word
#bindkey '^[^[[D' emacs-backward-word
#
#bindkey -s '^X^Z' '%-^M'
#bindkey '^[e' expand-cmd-path
#bindkey '^[^I' reverse-menu-complete
#bindkey '^X^N' accept-and-infer-next-history
#bindkey '^W' kill-region
#bindkey '^I' complete-word
## Fix weird sequence that rxvt produces
#bindkey -s '^[[Z' '\t'
#
