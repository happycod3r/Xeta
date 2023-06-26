#!/usr/bin/env zsh

local ret=0 # exit code

# Protect against running with shells other than zsh
if [ -z "$ZSH_VERSION" ]; then
  exec zsh "$0" "$@"
fi

# Protect against unwanted sourcing
case "$ZSH_EVAL_CONTEXT" in
  *:file) echo "error: this file should not be sourced" && return ;;
esac

cd "$XETA"

verbose_mode="default"
interactive=false

while getopts "v:i" opt; do
    case $opt in
        v)
            if [[ $OPTARG == default || $OPTARG == minimal || $OPTARG == silent ]]; then
                verbose_mode=$OPTARG
            else
                echo "[XETA] update verbosity '$OPTARG' is not valid"
                echo "[XETA] valid options are 'default', 'minimal' and 'silent'"
            fi
        ;;
        i) 
            interactive=true 
        ;;
    esac
done

# Use colors, but only if connected to a terminal
# and that terminal supports them.

# The [ -t 1 ] check only works when the function is not called from
# a subshell (like in `$(...)` or `(...)`, so this hack redefines the
# function at the top level to always return false when stdout is not
# a tty.
if [ -t 1 ]; then
    is_tty() {
        true
    }
else
    is_tty() {
        false
    }
fi

# This function uses the logic from supports-hyperlinks[1][2], which is
# made by Kat Marchán (@zkat) and licensed under the Apache License 2.0.
# [1] https://github.com/zkat/supports-hyperlinks
# [2] https://crates.io/crates/supports-hyperlinks
#
# Copyright (c) 2021 Kat Marchán
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
function supports_hyperlinks() { 
    # $FORCE_HYPERLINK must be set and be non-zero (this acts as a logic bypass)
    if [ -n "$FORCE_HYPERLINK" ]; then
        [ "$FORCE_HYPERLINK" != 0 ]
        return $?
    fi

    # If stdout is not a tty, it doesn't support hyperlinks
    is_tty || return 1

    # DomTerm terminal emulator (domterm.org)
    if [ -n "$DOMTERM" ]; then
        return 0
    fi

    # VTE-based terminals above v0.50 (Gnome Terminal, Guake, ROXTerm, etc)
    if [ -n "$VTE_VERSION" ]; then
        [ $VTE_VERSION -ge 5000 ]
        return $?
    fi

    # If $TERM_PROGRAM is set, these terminals support hyperlinks
    case "$TERM_PROGRAM" in
        Hyper|iTerm.app|terminology|WezTerm) 
            return 0 
        ;;
    esac

    # kitty supports hyperlinks
    if [ "$TERM" = xterm-kitty ]; then
        return 0
    fi

    # Windows Terminal also supports hyperlinks
    if [ -n "$WT_SESSION" ]; then
        return 0
    fi

    # Konsole supports hyperlinks, but it's an opt-in setting that can't be detected
    # https://github.com/ohmyzsh/ohmyzsh/issues/10964
    # if [ -n "$KONSOLE_VERSION" ]; then
    #   return 0
    # fi

    return 1
}

# Adapted from code and information by Anton Kochkov (@XVilka)
# Source: https://gist.github.com/XVilka/8346728
function supports_truecolor() {
    case "$COLORTERM" in
        truecolor|24bit) 
            return 0 
        ;;
    esac

    case "$TERM" in
        iterm           |\
        tmux-truecolor  |\
        linux-truecolor |\
        xterm-truecolor |\
        screen-truecolor) 
            return 0 
        ;;
    esac

    return 1
}

function fmt_link() {
    # $1: text, $2: url, $3: fallback mode
    if supports_hyperlinks; then
        printf '\033]8;;%s\033\\%s\033]8;;\033\\\n' "$2" "$1"
        return
    fi

    case "$3" in
        --text) 
            printf '%s\n' "$1" 
        ;;
        --url|*) 
            fmt_underline "$2" 
        ;;
    esac
}

function fmt_underline() {
  is_tty && printf '\033[4m%s\033[24m\n' "$*" || printf '%s\n' "$*"
}

setopt typeset_silent
typeset -a RAINBOW

if is_tty; then
    if supports_truecolor; then
        RAINBOW=(
            "$(printf '\033[38;2;255;0;0m')"
            "$(printf '\033[38;2;255;97;0m')"
            "$(printf '\033[38;2;247;255;0m')"
            "$(printf '\033[38;2;0;255;30m')"
            "$(printf '\033[38;2;77;0;255m')"
            "$(printf '\033[38;2;168;0;255m')"
            "$(printf '\033[38;2;245;0;172m')"
        )
    else
        RAINBOW=(
            "$(printf '\033[38;5;196m')"
            "$(printf '\033[38;5;202m')"
            "$(printf '\033[38;5;226m')"
            "$(printf '\033[38;5;082m')"
            "$(printf '\033[38;5;021m')"
            "$(printf '\033[38;5;093m')"
            "$(printf '\033[38;5;163m')"
        )
    fi

    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    BLUE=$(printf '\033[34m')
    BOLD=$(printf '\033[1m')
    RESET=$(printf '\033[0m')
fi

git remote -v | while read remote url extra; do
    case "$url" in
        https://github.com/happycod3r/xeta(|.git)) 
        ;;
        git@github.com:happycod3r/xeta(|.git)) 
        ;;
        *) 
            continue 
        ;;
    esac

    # If we reach this point we have found the proper ohmyzsh upstream remote. If we don't,
    # we'll only update from the set remote if `oh-my-zsh.remote` has been set to a remote,
    # as when installing from a fork.
    git config --local xeta.remote "$remote"
    break
done

    # Set git-config values known to fix git errors
    # Line endings (#4069)
    git config core.eol lf
    git config core.autocrlf false
    # zeroPaddedFilemode fsck errors (#4963)
    git config fsck.zeroPaddedFilemode ignore
    git config fetch.fsck.zeroPaddedFilemode ignore
    git config receive.fsck.zeroPaddedFilemode ignore
    # autostash on rebase (#7172)
    resetAutoStash=$(git config --bool rebase.autoStash 2>/dev/null)
    git config rebase.autoStash true

    local ret=0

    # repository settings
    remote=${"$(git config --local xeta.remote)":-origin}
    branch=${"$(git config --local xeta.branch)":-main}

    # repository state
    last_head=$(git symbolic-ref --quiet --short HEAD || git rev-parse HEAD)
    # checkout update branch
    git checkout -q "$branch" -- || exit 1
    # branch commit before update (used in changelog)
    last_commit=$(git rev-parse "$branch")

    # Update Xeta
    if [[ $verbose_mode != silent ]]; then
        printf "${BLUE}%s${RESET}\n" "Updating Xeta"
    fi
    if LANG= git pull --quiet --rebase $remote $branch; then
        # Check if it was really updated or not
        if [[ "$(git rev-parse HEAD)" = "$last_commit" ]]; then
            message="Xeta is already at the latest version."
        else
            message="Xeta has been updated!"

            # Save the commit prior to updating
            git config xeta.lastVersion "$last_commit"

            # Print changelog to the terminal
            if [[ $interactive == true && $verbose_mode == default ]]; then
                "$XTOOLS/changelog.sh" HEAD "$last_commit"
            fi

            if [[ $verbose_mode != silent ]]; then
                printf "${BLUE}%s \`${BOLD}%s${RESET}${BLUE}\`${RESET}\n" "You can see the changelog with" "xeta changelog"
            fi
        fi

        if [[ $verbose_mode == default ]]; then
            cat <<'EOF'

  8b        d8                                      
   Y8,    ,8P                ,d                     
    `8b  d8'                 88                     
      Y88P      ,adPPYba,  MM88MMM  ,adPPYYba,      
      d88b     a8P_____88    88     ""     `Y8      
    ,8P  Y8,   8PP"""""""    88     ,adPPPPP88      
   d8'    `8b  "8b,   ,aa    88,    88,    ,88      
  8P        Y8  `"Ybbd8"'    "Y888  `"8bbdP"Y8
           01011000 01100101 01110100 01100001          
           
v1.0.0

EOF
            printf "${BLUE}%s${RESET}\n\n"
            # printf "${BLUE}${BOLD}%s %s${RESET}\n" "To keep up with the latest news and updates, follow us on Twitter:" "$(fmt_link @xeta-framework https://twitter.com/xeta-framework)"
            # printf "${BLUE}${BOLD}%s %s${RESET}\n" "Want to get involved in the community? Join our Discord:" "$(fmt_link "Discord server" https://discord.gg/xeta-framework)"
        elif [[ $verbose_mode == minimal ]]; then
            printf "${BLUE}%s${RESET}\n"
        fi
    else
        ret=$?
        printf "${RED}%s${RESET}\n" 'There was an error updating. Try again later?'
    fi

    # go back to HEAD previous to update
    git checkout -q "$last_head" --

    # Unset git-config values set just for the upgrade
    case "$resetAutoStash" in
        "") 
            git config --unset rebase.autoStash 
        ;;
        *) 
            git config rebase.autoStash "$resetAutoStash" 
        ;;
    esac

    # Exit with `1` if the update failed
    exit $ret
