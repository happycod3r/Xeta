#!/usr/bin/env zsh

function xeta {
    [[ $# -gt 0 ]] || {
        _xeta::help
        return 1
    }

    local command="$1"
    shift

    # Subcommand functions start with _ so that they don't
    # appear as completion entries when looking for `xeta`
    (( $+functions[_xeta::$command] )) || {
        _xeta::help
        return 1
    }

    _xeta::$command "$@"
}

function _xeta {
    local -a cmds subcmds
    cmds=(
        'help:Usage information'
        'credits:View credits and thanks'
        'version:Show the current version'
        'reload:Reload the current zsh session'
        'update:Update Xeta'
        'backup:Make a backup of Xeta'
        'uninstall:Uninstall Xeta'
        'changelog:Print the changelog'
        'pr:Manage Xeta Pull Requests'
        'plugin:Manage plugins'
        'theme:Manage themes'
        'aliases:Manage aliases'
        'util:Access utilities'
        'edit:View and Edit config files'
        'stats:Show various stats'
        'git:Manage a repository'
        'user:Manage user settigs'
        'toggle:Enable/disable settings'
    )
 
    if (( CURRENT == 2 )); then
        _describe 'command' cmds
    elif (( CURRENT == 3 )); then
        case "$words[2]" in
            changelog) 
                local -a refs
                refs=("${(@f)$(builtin cd -q "$XETA"; command git for-each-ref --format="%(refname:short):%(subject)" refs/heads refs/tags)}")
                _describe 'command' refs 
            ;;
            pr) 
                subcmds=(
                    'clean:Delete all pull request branches' 
                    'test:Test a pull request'
                )
                _describe 'command' subcmds 
            ;;
            plugin) 
                subcmds=(
                    'disable:Disable plugin(s)'
                    'enable:Enable plugin(s)'
                    'info:Get plugin information'
                    'list:List all plugins'
                    'load:Load plugin(s)'
                    'path:Get the path to plugin(s)'
                    'remove:Delete plugin(s)'
                    'update:Update plugin(s)'
                )
                _describe 'command' subcmds 
            ;;
            theme) 
                subcmds=(
                    'list:List all themes'
                    'preview:Preview a theme'
                    'previews:Show previews of all themes'
                    'set:Set a theme in your .zshrc file' 
                    'use:Load a theme for this session'  
                    'fav:Add a theme to your favorites' 
                    'unfav:Remove a theme from your favorites' 
                    'lsfav:List the themes in your favorites list'
                )
                _describe 'command' subcmds  
            ;;
            aliases)
                subcmds=(
                    'list:List aliases' 
                    'add:Define a new alias' 
                    'remove:Remove a defined alias' 
                    'cmd_for:Get the command for an alias name' 
                    'name_for:Get the alias name for a command' 
                    'containing:Get aliases containing the specified command'
                )
                _describe 'command' subcmds
            ;;
            util)
                subcmds=(
                    'extract:Extract an archive file'
                )
                _describe 'command' subcmds
            ;;
            edit)
                subcmds=(
                    'zshrc:Edit your .zshrc'
                    'bashrc:Edit your .bashrc'
                    'config:Edit your xeta.conf'
                    'favs:Edit theme-favlist.conf'
                    'aliases:Edit your aliases.conf'
                    'globals:Edit your globals.conf'
                    'keybinds:Edit your key-binds.conf'
                    'path:Edit your path.conf'
                    'jumppoints:Edit your jump-points.conf'
                )
                _describe 'command' subcmds
            ;;
            stats)
                subcmds=(
                    'cmds:View stats on the top 20 most used commands'
                )
                _describe 'command' subcmds
            ;;
            git)
                subcmds=(
                    'status:Print repository status'
                    'commit:Create a new commit'
                )
                _describe 'command' subcmds
            ;;
            user)
                subcmds=(
                    'username:Manage your username'
                    'password:Manage your password'
                    'pin:Manage your pin'
                    'email:Manage your email'
                )
                _describe 'command' subcmds
            ;;
            toggle)
                subcmds=(
                    'sudo:Toggle default to sudo commands'
                )
                _describe 'command' subcmds
            ;;
        esac
    elif (( CURRENT == 4 )); then
        case "${words[2]}::${words[3]}" in
            plugin::(disable|enable|load))
                local -aU valid_plugins
                if [[ "${words[3]}" = disable ]]; then
                    # if command is "disable", only offer already enabled plugins
                    valid_plugins=($plugins)
                else
                    valid_plugins=(
                        "$XPLUGS"/*/{_*,*.plugin.zsh}(-.N:h:t) 
                        "$XCUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t)
                    )
                    # if command is "enable", remove already enabled plugins
                    [[ "${words[3]}" = enable ]] && valid_plugins=(${valid_plugins:|plugins})
                fi

                _describe 'plugin' valid_plugins 
            ;;
            plugin::info)
                local -aU plugins
                plugins=(
                    "$XPLUGS"/*/{_*,*.plugin.zsh}(-.N:h:t) 
                    "$XCUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t)
                )
                _describe 'plugin' plugins 
            ;;
            plugin::path)
                local -aU plugins
                plugins=(
                    "$XPLUGS"/*/{_*,*.plugin.zsh}(-.N:h:t) 
                    "$XCUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t)
                )
                _describe 'plugin' plugins
            ;;
            plugin::remove)
                local -aU plugins
                plugins=(
                    "$XPLUGS"/*/{_*,*.plugin.zsh}(-.N:h:t) 
                    "$XCUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t)
                )
                _describe 'plugin' plugins     
            ;;
            theme::(set|use|preview|fav|unfav))
                local -aU themes
                themes=(
                    "$XTHEMES"/*.zsh-theme(-.N:t:r) 
                    "$XCUSTOM"/**/*.zsh-theme(-.N:r:gs:"$XCUSTOM"/themes/:::gs:"$XCUSTOM"/:::)
                )
                _describe 'theme' themes 
            ;;
            git::(commit))
                subcmds=(
                    'all:Commit all changes' 
                    'specific:Commit specific changes'
                )
                _describe 'command' subcmds
            ;;
            user::(username))
                subcmds=(
                    'set:Set your username'
                    'unset:Unset your username'
                )
                _describe 'command' subcmds
            ;;
            user::(password))
                subcmds=(
                    'set:Set your password'
                    'unset:Unset your password'
                )
                _describe 'command' subcmds
            ;;
            user::(pin))
                subcmds=(
                    'set:Set your pin'
                    'unset:Unset your pin'
                )
                _describe 'command' subcmds
            ;;
            user::(email))
                subcmds=(
                    'set:Set your email'
                    'unset:Unset your email'
                )
                _describe 'command' subcmds
            ;;
        esac
    elif (( CURRENT > 4 )); then
        case "${words[2]}::${words[3]}" in
            plugin::(enable|disable|load))
                local -aU valid_plugins

                if [[ "${words[3]}" = disable ]]; then
                    # if command is "disable", only offer already enabled plugins
                    valid_plugins=($plugins)
                else
                    valid_plugins=(
                        "$XPLUGS"/*/{_*,*.plugin.zsh}(-.N:h:t) 
                        "$XCUSTOM"/plugins/*/{_*,*.plugin.zsh}(-.N:h:t)
                    )
                    # if command is "enable", remove already enabled plugins
                    [[ "${words[3]}" = enable ]] && valid_plugins=(${valid_plugins:|plugins})
                fi

                # Remove plugins already passed as arguments
                # NOTE: $(( CURRENT - 1 )) is the last plugin argument completely passed, i.e. that which
                # has a space after them. This is to avoid removing plugins partially passed, which makes
                # the completion not add a space after the completed plugin.
                local -a args
                args=(${words[4,$(( CURRENT - 1))]})
                valid_plugins=(${valid_plugins:|args})
 
                _describe 'plugin' valid_plugins 
            ;;
        esac
    fi

    return 0
}

# If run from a script, do not set the completion function
if (( ${+functions[compdef]} )); then
    compdef _xeta xeta
fi

#//////////// * Utility functions * //////

function _xeta::confirm {
    # If question supplied, ask it before reading the answer
    # NOTE: uses the logname of the caller function
    if [[ -n "$1" ]]; then
        _xeta::log prompt "$1" "${${functrace[1]#_}%:*}"
    fi

    # Read one character
    read -r -k 1

    # If no newline entered, add a newline
    if [[ "$REPLY" != $'\n' ]]; then
        echo
    fi
}

function _xeta::log {
    # if promptsubst is set, a message with `` or $()
    # will be run even if quoted due to `print -P`
    setopt localoptions nopromptsubst

    # $1 = info|warn|error|debug
    # $2 = text
    # $3 = (optional) name of the logger

    local logtype=$1
    local logname=${3:-${${functrace[1]#_}%:*}}

    # Don't print anything if debug is not active
    if [[ $logtype = debug && -z $_XETA_DEBUG ]]; then
        return
    fi

    # Choose coloring based on log type
    case "$logtype" in
        prompt) 
            print -Pn "%S%F{blue}$logname%f%s: $2" 
        ;;
        debug) 
            print -P "%F{white}$logname%f: $2" 
        ;;
        info) 
            print -P "%F{green}$logname%f: $2" 
        ;;
        warn) 
            print -P "%S%F{yellow}$logname%f%s: $2" 
        ;;
        error) 
            print -P "%S%F{red}$logname%f%s: $2" 
        ;;
    esac >&2
}

#//////////// * User commands * //////

function _xeta::help {
    cat >&2 <<EOF

        [04mUsage[24m: xeta [03m[command][23m

        [04mAvailable commands[24m:

        [04mhelp[24m                       Print this help message
        [04mcredits[24m                    View credits and thanks
        [04mversion[24m                    Show the version
        [04mreload[24m                     Reload the current zsh session
        [04mupdate[24m                     Update Xeta
        [04mbackup[24m                     Make a backup of Xeta
        [04muninstall[24m                  Uninstall Xeta
        [04mchangelog[24m                  Print the changelog
        [04mpr[24m           [03m[command][23m     Manage Xeta pull requests
        [04mplugin[24m       [03m[cmd1 ...][23m    Manage plugins
        [04mtheme[24m        [03m[cmd1 ...][23m    Manage themes
        [04maliases[24m      [03m[cmd1 ...][23m    Manage aliases
        [04mutil[24m         [03m[command][23m     Access utilities
        [04medit[24m         [03m[command][23m     View and edit config files
        [04mstats[24m        [03m[command][23m     Show various stats
        [04mgit[24m          [03m[cmd1 ...][23m    Manage a repository
        [04muser[24m         [03m[cmd1 ...][23m    Manage user settigs 
        [04mtoggle[24m       [03m[command][23m     Enable/disable settings


EOF
}

function _xeta::credits {
    echo -e "
    [0;1;35;95mOh-My-Zsh v5.0.8${reset_color}
        https://github.com/ohmyzsh 
    [0;1;31;91mZsh-Syntax Highlighting v0.8.0${reset_color}
        https://github.com/zsh-users/zsh-syntax-highlighting
    [0;1;33;93mZsh-Auto-Suggestions v0.7.0${reset_color}
        https://github.com/zsh-users/zsh-autosuggestions 
    [0;1;32;92mZsh-Navigation-Tools v5.0.0${reset_color}
        https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/zsh-navigation-tools
    [0;1;36;96mfzf (Fuzzy Finder) v0.42.0${reset_color}
        https://github.com/junegunn/fzf
    [0;1;35;95mAutoenv/Direnv v0.3.0${reset_color}
        https://github.com/hyperupcall/autoenv 
    [0;1;31;91mPowerlevel10K v1.19.0${reset_color}
        https://github.com/romkatv/powerlevel10k
    [0;1;33;93mSpaceship Prompt v4.14.0${reset_color}
        https://spaceship-prompt.sh/
"
}

function _xeta::version {
    (
        builtin cd -q "$XETA"

        # Get the version name:
        # 1) try tag-like version
        # 2) try branch name
        # 3) try name-rev (tag~<rev> or branch~<rev>)
        local version version_file
        version_file="${XCONFIG}/version.conf"

        if [[ -n "$XETA_VERSION" && ! -z "$XETA_VERSION" ]]; then
            version="$XETA_VERSION"
            io::space
            io::notify "Current version:${reset_color}"
            printf "%s\n" "$version"
            io::space
            return
        else
            version=$(command git describe --tags HEAD 2>/dev/null) \
            || version=$(command git sy mbolic-ref --quiet --short HEAD 2>/dev/null) \
            || version=$(command git name-rev --no-undefined --name-only --exclude="remotes/*" HEAD 2>/dev/null) \
            || version="<detached>"

            # Get short hash for the current HEAD
            local commit=$(command git rev-parse --short HEAD 2>/dev/null)
            # Show version and commit hash
            io::notify
            printf "%s (%s)\n" "$version" "$commit"
            io::space
        fi
    )
} 

function _xeta::reload {
    io::noify "Reloading Zsh session ..."
    io::space
    # Delete current completion cache
    command rm -f $_comp_dumpfile $ZSH_COMPDUMP

    # Old zsh versions don't have ZSH_ARGZERO
    local zsh="${ZSH_ARGZERO:-${functrace[-1]%:*}}"
    # Check whether to run a login shell
    [[ "$zsh" = -* || -o login ]] && exec -l "${zsh#-}" || exec "$zsh"
}

function _xeta::update {
    io::notify "Updating Xeta (if there is one) ..."
    io::space
    local last_commit=$(builtin cd -q "$XETA"; git rev-parse HEAD)

    # Run update script
    zstyle -s ':xeta:update' verbose verbose_mode || verbose_mode=default
    if [[ "$1" != --unattended ]]; then
        XETA="$XETA" command zsh -f "$XTOOLS/upgrade.sh" -i -v $verbose_mode || return $?
    else
        XETA="$XETA" command zsh -f "$XTOOLS/upgrade.sh" -v $verbose_mode || return $?
    fi

    # Update last updated file
    zmodload zsh/datetime
    echo "LAST_EPOCH=$(( EPOCHSECONDS / 60 / 60 / 24 ))" >! "${XCACHE}/.zsh-update"
    # Remove update lock if it exists
    command rm -rf "$XLOG/update.lock"

    # Restart the zsh session if there were changes
    if [[ "$1" != --unattended && "$(builtin cd -q "$XETA"; git rev-parse HEAD)" != "$last_commit" ]]; then
        # Old zsh versions don't have ZSH_ARGZERO
        local zsh="${ZSH_ARGZERO:-${functrace[-1]%:*}}"
        # Check whether to run a login shell
        [[ "$zsh" = -* || -o login ]] && exec -l "${zsh#-}" || exec "$zsh"
    fi
}      

function _xeta::backup {
    io::yesno "Make a backup?" && {
        XETA="${XETA:-~/.xeta}"
        BACKUP_DIR="${HOME}/xeta-backups"
        BACKUP_NAME="xeta.backup-$(date).zip"
        io::notify "Creating backup @ $BACKUP_DIR/$BACKUP_NAME"
        sudo mkdir "$BACKUP_DIR"
        sudo zip -r "${$BACKUP_DIR}/${BACKUP_NAME}" "$XETA" || {
            io::err "Failed to create backup is zip installed?"
            return 1
        }
        io::notify "Backup was created @$(date)."
        return 0
    }
    io::notify "No backup was created."
}

function _xeta::uninstall {
    function uninstall_xeta() { env XETA="$XETA" sh "${XTOOLS}/uninstall.sh"; }
    # Implement pin system.
    io::notify "Hello! Sorry to see you go :(${reset_color}\n"
    io::yesno "are you sure you want to uninstall Xeta? (y/n)" && {
        echo "Okay uninstalling now..."
        uninstall_xeta || io::err "uninstall script faied!"
    }
}

function _xeta::changelog {
    local version=${1:-HEAD} format=${3:-"--text"}

    if (
        builtin cd -q "$XETA"
        ! command git show-ref --verify refs/heads/$version && \
        ! command git show-ref --verify refs/tags/$version && \
        ! command git rev-parse --verify "${version}^{commit}"
    ) &>/dev/null; then
        cat >&2 <<EOF
            Usage: ${(j: :)${(s.::.)0#_}} [version]

            NOTE: <version> must be a valid branch, tag or commit.
EOF
        return 1
    fi
    builtin cd $XETA
    sudo zsh "${XTOOLS}/changelog.sh" "$version" "${2:-}" "$format" "$XLOG"

}

function _xeta::pr {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04mclean[24m                      Delete all PR branches (xeta/pull-*)
    [04mtest[24m    [03m[pr_number|url][23m    Fetch PR #NUMBER and rebase against main


EOF
        return 1
    }

    local command="$1"
    shift

    $0::$command "$@"
}

function _xeta::pr::clean {
    (
        set -e
        builtin cd -q "$XETA"

        # Check if there are PR branches
        local fmt branches
        fmt="%(color:bold blue)%(align:18,right)%(refname:short)%(end)%(color:reset) %(color:dim bold red)%(objectname:short)%(color:reset) %(color:yellow)%(contents:subject)"
        branches="$(command git for-each-ref --sort=-committerdate --color --format="$fmt" "refs/heads/xeta/pull-*")"

        # Exit if there are no PR branches
        if [[ -z "$branches" ]]; then
            _xeta::log info "there are no Pull Request branches to remove."
            return
        fi

        # Print found PR branches
        echo "$branches\n"
        # Confirm before removing the branches
        _xeta::confirm "do you want remove these Pull Request branches? [Y/n] "
        # Only proceed if the answer is a valid yes option
        [[ "$REPLY" != [yY$'\n'] ]] && return

            _xeta::log info "removing all Xeta Pull Request branches..."
            command git branch --list 'xeta/pull-*' | while read branch; do
                command git branch -D "$branch"
            done
    )
}

function _xeta::pr::test {
    # Allow $1 to be a URL to the pull request
    if [[ "$1" = https://* ]]; then
        1="${1:t}"
    fi

    # Check the input
    if ! [[ -n "$1" && "$1" =~ ^[[:digit:]]+$ ]]; then
        echo >&2 "[04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[pr_number|url][23m"
        return 1
    fi
    
    # Save current git HEAD
    local branch
    branch=$(builtin cd -q "$XETA"; git symbolic-ref --short HEAD) || {
        _xeta::log error "error when getting the current git branch. Aborting..."
        io::err "error when getting the current git branch. Aborting..."
        return 1
    }


    # Fetch PR onto xeta/pull-<PR_NUMBER> branch and rebase against main
    # If any of these operations fail, undo the changes made
    (
        set -e
        builtin cd -q "$XETA"

        # Get the xeta git remote
        command git remote -v | while read remote url _; do
            case "$url" in
                https://github.com/happycod3r/xeta(|.git)) 
                    found=1 
                    break 
                ;;
                git@github.com:happycod3r/xeta(|.git)) 
                    found=1 
                    break 
                ;;
            esac
        done

        (( $found )) || {
            _xeta::log error "could not find the xeta git remote. Aborting..."
            return 1
        }

        # Fetch pull request head
        _xeta::log info "fetching PR #$1 to xeta/pull-$1..."
        command git fetch -f "$remote" refs/pull/$1/head:xeta/pull-$1 || {
            _xeta::log error "error when trying to fetch PR #$1."
            return 1
        }

        # Rebase pull request branch against the current main
        _xeta::log info "rebasing PR #$1..."
        local ret gpgsign
        {
            # Back up commit.gpgsign setting: use --local to get the current repository
            # setting, not the global one. If --local is not a known option, it will
            # exit with a 129 status code.
            gpgsign=$(command git config --local commit.gpgsign 2>/dev/null) || ret=$?
            [[ $ret -ne 129 ]] || gpgsign=$(command git config commit.gpgsign 2>/dev/null)
            command git config commit.gpgsign false

            command git rebase main xeta/pull-$1 || {
                command git rebase --abort &>/dev/null
                _xeta::log warn "could not rebase PR #$1 on top of main."
                _xeta::log warn "you might not see the latest stable changes."
                _xeta::log info "run \`zsh\` to test the changes."
                return 1
            }
        } always {
            case "$gpgsign" in
                "") 
                    command git config --unset commit.gpgsign 
                ;;
                *) 
                    command git config commit.gpgsign "$gpgsign" 
                ;;
            esac
        }

        _xeta::log info "fetch of PR #${1} successful."
    )

    # If there was an error, abort running zsh to test the PR
    [[ $? -eq 0 ]] || return 1

    # Run zsh to test the changes
    _xeta::log info "running \`zsh\` to test the changes. Run \`exit\` to go back."
    command zsh -l

    # After testing, go back to the previous HEAD if the user wants
    _xeta::confirm "do you want to go back to the previous branch? [Y/n] "
    # Only proceed if the answer is a valid yes option
    [[ "$REPLY" != [yY$'\n'] ]] && return

    (
        set -e
        builtin cd -q "$XETA"

        command git checkout "$branch" -- || {
            _xeta::log error "could not go back to the previous branch ('$branch')."
            return 1
        }
    )
}

function _xeta::plugin {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:
        
    [04mdisable[24m    [03m[plugin1 ...][23m     Disable plugin(s)
    [04menable[24m     [03m[plugin1 ...][23m     Enable plugin(s)
    [04minfo[24m       [03m[plugin][23m          Get information on a plugin
    [04mlist[24m                         List all available plugins
    [04mload[24m       [03m[plugin1 ...][23m     Load plugin(s)
    [04mpath[24m       [03m[plugin1 ...][23m     Get the absolute path to plugin(s)
    [04mremove[24m     [03m[plugin1 ...][23m     Remove plugin(s)
    [04mupdate[24m     [03m[plugin1 ...][23m     Update plugin(s)
    

EOF
        return 1
    }

    local command="$1"
    shift

    $0::$command "$@"
}

function _xeta::plugin::disable {
    
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[plugin1 ...][23m


EOF
        return 1
    }

    # Check that plugin is in $plugs
    local -a dis_plugins
    for plugin in "$@"; do
        if [[ ${plugins[(Ie)$plugin]} -eq 0 ]]; then
            _xeta::log warn "plugin '$plugin' is not enabled."
            continue
        fi
        dis_plugins+=("$plugin")
    done

    # Exit if there are no enabled plugins to disable
    if [[ ${#dis_plugins} -eq 0 ]]; then
        return 1
    fi

    # Remove plugins substitution awk script
    local awk_subst_plugins="\
        gsub(/[ \t]+(${(j:|:)dis_plugins})/, \"\") # with spaces before
        gsub(/(${(j:|:)dis_plugins})[ \t]+/, \"\") # with spaces after
        gsub(/\((${(j:|:)dis_plugins})\)/, \"\") # without spaces (only plugin)
    "
    # Disable plugins awk script
    local awk_script="
        # if plugins=() is in oneline form, substitute disabled plugins and go to next line
        /^[ \t]*plugins=\([^#]+\).*\$/ {
            $awk_subst_plugins
            print \$0
            next
        }

        # if plugins=() is in multiline form, enable multi flag and disable plugins if they're there
        /^[ \t]*plugins=\(/ {
            multi=1
            $awk_subst_plugins
            print \$0
            next
        }

        # if multi flag is enabled and we find a valid closing parenthesis, remove plugins and disable multi flag
        multi == 1 && /^[^#]*\)/ {
            multi=0
            $awk_subst_plugins
            print \$0
            next
        }

        multi == 1 && length(\$0) > 0 {
        $awk_subst_plugins
        if (length(\$0) > 0) print \$0
            next
        }

        { print \$0 }
    "

    local zdot="${ZDOTDIR:-$HOME}"
    local xconfig="${${:-"${XCONFIG}/xeta.conf"}:A}"
    
    awk "$awk_script" "$xconfig" > "$xconfig.new" \
    && command cp -f "$xconfig" "$xconfig.bck" \
    && command mv -f "$xconfig.new" "$xconfig"

    # Exit if the new .zshrc file wasn't created correctly
    [[ $? -eq 0 ]] || {
        local ret=$?
        _xeta::log error "error disabling plugins."
        return $ret
    }

    # Exit if the new .zshrc file has syntax errors
    if ! command zsh -n "$xconfig"; then
        _xeta::log error "broken syntax in '"${zdot/#$HOME/\~}/.xeta/xenv/config/xeta.conf"'. Rolling back changes..."
        command mv -f "$xconfig.bck" "$xconfig"
        return 1
    fi

    # Restart the zsh session if there were no errors
    _xeta::log info "plugins disabled: ${(j:, :)dis_plugins}."

    # Only reload zsh if run in an interactive session
    [[ ! -o interactive ]] || _xeta::reload
}

function _xeta::plugin::enable {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[plugin1 ...][23m


EOF
        return 1
    }

    # Check that plugin is not in $plugs
    local -a add_plugins
    for plugin in "$@"; do
        if [[ ${plugins[(Ie)$plugin]} -ne 0 ]]; then
            _xeta::log warn "plugin '$plugin' is already enabled."
            continue
        fi
        add_plugins+=("$plugin")
    done

    # Exit if there are no plugins to enable
    if [[ ${#add_plugins} -eq 0 ]]; then
        return 1
    fi

    # Enable plugins awk script
    local awk_script="
        # if plugins=() is in oneline form, substitute ) with new plugins and go to the next line
        /^[ \t]*plugins=\([^#]+\).*\$/ {
        sub(/\)/, \" $add_plugins&\")
        print \$0
        next
        }

        # if plugs=() is in multiline form, enable multi flag
        /^[ \t]*plugins=\(/ {
        multi=1
        }

        # if multi flag is enabled and we find a valid closing parenthesis,
        # add new plugins and disable multi flag
        multi == 1 && /^[^#]*\)/ {
        multi=0
        sub(/\)/, \" $add_plugins&\")
        print \$0
        next
        }

        { print \$0 }
    "

    local zdot="${ZDOTDIR:-$HOME}"
    local xconfig="${${:-"${XCONFIG}/xeta.conf"}:A}"
    awk "$awk_script" "$xconfig" > "$xconfig.new" \
    && command cp -f "$xconfig" "$xconfig.bck" \
    && command mv -f "$xconfig.new" "$xconfig"

    # Exit if the new .zshrc file wasn't created correctly
    [[ $? -eq 0 ]] || {
        local ret=$?
        _xeta::log error "error enabling plugins."
        return $ret
    }

    # Exit if the new .zshrc file has syntax errors
    if ! command zsh -n "$xconfig"; then
        _xeta::log error "broken syntax in '"${zdot/#$HOME/\~}/.xeta/xenv/config/xeta.conf"'. Rolling back changes..."
        command mv -f "$xconfig.bck" "$xconfig"
        return 1
    fi

    # Restart the zsh session if there were no errors
    _xeta::log info "plugins enabled: ${(j:, :)add_plugins}."

    # Only reload zsh if run in an interactive session
    [[ ! -o interactive ]] || _xeta::reload
}

function _xeta::plugin::info {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[plugin][23m


EOF
        return 1
    }

    local readme
    for readme in "${XCUSTOM}/plugs/$1/README.md" "${XPLUGS}/$1/README.md"; do
        if [[ -f "$readme" ]]; then
            (( ${+commands[less]} )) && less "$readme" || cat "$readme"
            return 0
        fi
    done

    if [[ -d "$XCUSTOM/plugs/$1" || -d "$XPLUGS/$1" ]]; then
        _xeta::log error "the '$1' plugin doesn't have a README file"
    else
        _xeta::log error "'$1' plugin not found"
    fi

    return 1
}

function _xeta::plugin::list {
    local -a custom_plugins builtin_plugins
    custom_plugins=("$XCUSTOM"/plugins/*(-/N:t))
    builtin_plugins=("$XPLUGS"/*(-/N:t))
    # If the command is being piped, print all found line by line
    if [[ ! -t 1 ]]; then
        print -l ${(q-)custom_plugins} ${(q-)builtin_plugins}
        return
    fi

    if (( ${#custom_plugins} )); then
        print -P "%U%BCustom plugins%b%u:"
        print -lac ${(q-)custom_plugins}
    fi

    if (( ${#builtin_plugins} )); then
        (( ${#custom_plugins} )) && echo # add a line of separation

        print -P "%U%BBuilt-in plugins%b%u:"
        print -lac ${(q-)builtin_plugins}
    fi
    io::space
}

function _xeta::plugin::load {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[plugin1 ...][23m


EOF
        return 1
    }

    local plugin base has_completion=0

    for plugin in "$@"; do
        if [[ -d "$XCUSTOM/plugins/$plugin" ]]; then
            base="$XCUSTOM/plugins/$plugin"
        elif [[ -d "$XPLUGS/$plugin" ]]; then
            base="$XPLUGS/$plugin"
        else
            _xeta::log warn "plugin '$plugin' not found"
            continue
        fi

        # Check if its a valid plugin
        if [[ ! -f "$base/_$plugin" && ! -f "$base/$plugin.plugin.zsh" ]]; then
            _xeta::log warn "'$plugin' is not a valid plugin"
            continue
            # It it is a valid plugin, add its directory to $fpath unless it is already there
        elif (( ! ${fpath[(Ie)$base]} )); then
            fpath=("$base" $fpath)
        fi

        # Check if it has completion to reload compinit
        local -a comp_files
        comp_files=($base/_*(N))
        has_completion=$(( $#comp_files > 0 ))

        # Load the plugin
        if [[ -f "$base/$plugin.plugin.zsh" ]]; then
            builtin source "$base/$plugin.plugin.zsh"
        fi
    done

    # If we have completion, we need to reload the completion
    # We pass -D to avoid generating a new dump file, which would overwrite our
    # current one for the next session (and we don't want that because we're not
    # actually enabling the plugins for the next session).
    # Note that we still have to pass -d "$_comp_dumpfile", so that compinit
    # doesn't use the default zcompdump location (${ZDOTDIR:-$HOME}/.zcompdump).
    if (( has_completion )); then
        compinit -D -d "$_comp_dumpfile"
    fi
}

function _xeta::plugin::path {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[plugin1 ...][23m


EOF
        return 1
    }

    # Make sure we only load .plugin.zsh files and from the correct path.
    for _plugin in $plugins; do
        if [[ "$_plugin" == "$1" ]]; then
            io::notify "\"%s\" is located in the following location:${reset_color}\n%s\n" "$_plugin" "${XPLUGS}/$1/$1.plugin.zsh"
        elif [[ "$_plugin" != "$1" ]]; then
            io::notify "plugin \"%s\" not found" "$1"
            return
        fi
    done
    unset $_plugin
}
 
function _xeta::plugin::remove {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[plugin1 ...][23m


EOF
        return 1
    }

    # Make sure we only load .plugin.zsh files and from the correct path.
    for _plugin in $plugins; do
        if [[ "$_plugin" == "$1" ]]; then   
            io::yesno "This will remove the $1 plugin from your computer. Do you wish to continue? "
            local answer=$? 
            if [[ $answer -eq 1 ]]; then
                sudo rm -r "${XPLUGS}/$1"
                io::notify "$1 has been removed.\n"
            else
                return 0                
            fi
        elif [[ "$_plugin" != "$1" ]]; then
            io::notify "plugin \"%s\" not found" "$1"
            return 0
        fi
    done
    unset $_plugin
}

function _xeta::plugin::update {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[plugin1 ...][23m


EOF
        return 1
    }
}

function _xeta::theme {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04mlist[24m                        List all available Xeta themes
    [04mpreview[24m     [03m[theme1 ...][23m    Preview a theme(s)
    [04mpreviews[24m                    Preview all available themes
    [04mset[24m         [03m[theme][23m         Set a theme in your [03m.zshrc[23m file
    [04muse[24m         [03m[theme][23m         Load a theme
    [04mfav[24m         [03m[theme1 ...][23m    Add a theme(s) to your favorites
    [04munfav[24m       [03m[theme1 ...][23m    Remove a theme(s) from your favorites
    [04mlsfav[24m                       List themes in your favorites list


EOF
        return 1
    }

    custom_themes=("$XCUSTOM"/**/*.zsh-theme(-.N:r:gs:"$XCUSTOM"/themes/:::gs:"$XCUSTOM"/:::))
    builtin_themes=("$XTHEMES"/*.zsh-theme(-.N:t:r))
    themes=(${custom_themes} ${builtin_themes})

    local command="$1"
    shift

    $0::$command "$@" "$themes"
}

function _xeta::theme::list {
    local -a custom_themes builtin_themes
    custom_themes=("$XCUSTOM"/**/*.zsh-theme(-.N:r:gs:"$XCUSTOM"/themes/:::gs:"$XCUSTOM"/:::))
    builtin_themes=("$XTHEMES"/*.zsh-theme(-.N:t:r))
    # If the command is being piped, print all found line by line
    if [[ ! -t 1 ]]; then
        print -l ${(q-)custom_themes} ${(q-)builtin_themes}
        return
    fi

    # Print theme in use
    if [[ -n "$XTHEME" ]]; then
        print -Pn "%U%BCurrent theme%b%u: "
        [[ $XTHEME = random ]] && echo "$RANDOM_THEME (via random)" || echo "$XTHEME"
        echo
    fi

    # Print custom themes if there are any
    if (( ${#custom_themes} )); then
        print -P "%U%BCustom themes%b%u:"
        print -lac ${(q-)custom_themes}
        echo
    fi

    # Print built-in themes
    print -P "%U%BBuilt-in themes%b%u:"
    print -lac ${(q-)builtin_themes}
    io::space
}

function _xeta::theme::preview {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[theme][23m


EOF
        return 1
    }
    THEME=$1
    THEME_NAME="$THEME.zsh-theme"
    print "$fg[blue]${(l.((${COLUMNS}-${#THEME_NAME}-5))..─.)}$reset_color $THEME_NAME $fg[blue]───$reset_color"
    source "$XTHEMES/$THEME_NAME"
    cols=$(tput cols)
    (exit 1)
    print -P "$PROMPT                                                                                      $RPROMPT"
    source "$XTHEMES/$XTHEME".*
}

function _xeta::theme::previews {
    themes="$1"
    function theme_preview() {
        THEME=$1
        THEME_NAME=`echo $THEME | sed s/\.zsh-theme$//`
        print "$fg[blue]${(l.((${COLUMNS}-${#THEME_NAME}-5))..─.)}$reset_color $THEME_NAME $fg[blue]───$reset_color"
        source "${XTHEMES}/${THEME}"
        cols=$(tput cols)
        (exit 1)
        print -P "$PROMPT                                                                                      $RPROMPT"
    }

    for THEME in $(ls $XTHEMES); do
        echo
        theme_preview $THEME
        echo    
    done
    source "${XTHEMES}/${XTHEME}.zsh-theme"
    cols=$(tput cols)
}

function _xeta::theme::set {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[theme][23m


EOF
        return 1
    }

    # Check that theme exists
    if [[ ! -f "$XCUSTOM/$1.zsh-theme" ]] \
        && [[ ! -f "$XCUSTOM/themes/$1.zsh-theme" ]] \
        && [[ ! -f "$XTHEMES/$1.zsh-theme" ]]; then
        _xeta::log error "%B$1%b theme not found"
        return 1
    fi

    # Enable theme in .zshrc
    local awk_script='
        !set && /^[ \t]*XTHEME=[^#]+.*$/ {
            set=1
            sub(/^[ \t]*XTHEME=[^#]+.*$/, "XTHEME=\"'$1'\" # set by `xeta-framework cli`")
            print $0
            next
        }

        { print $0 }

        END {
            # If no XTHEME= line was found, return an error
            if (!set) exit 1
        }
    '

    local zdot="${ZDOTDIR:-$HOME}"
    local xconfig="${${:-"${XCONFIG}/xeta.conf"}:A}"
    awk "$awk_script" "$xconfig" > "$XCONFIG/xeta.conf.new" \
    || {
        # Prepend XTHEME= line to .zshrc if it doesn't exist
        cat <<EOF
            XTHEME="$1" # set by \`xeta\`

EOF
        cat "$XCONFIG/xeta.conf"
    } > "$XCONFIG/xeta.conf.new" \
    && command cp -f "$xconfig" "$XCONFIG/xeta.conf.bck" \
    && command mv -f "$XCONFIG/xeta.conf.new" "$xconfig"

    # Exit if the new .zshrc file wasn't created correctly
    [[ $? -eq 0 ]] || {
        local ret=$?
        _xeta::log error "error setting theme."
        return $ret
    }

    # Exit if the new .zshrc file has syntax errors
    if ! command zsh -n "$XCONFIG/xeta.conf"; then
        _xeta::log error "broken syntax in '"${zdot/#$HOME/\~}/.xeta/xenv/config/xeta.conf"'. Rolling back changes..."
        command mv -f "$XCONFIG/xeta.conf.bck" "$xconfig"
        return 1
    fi

    # Restart the zsh session if there were no errors
    _xeta::log info "'$1' theme set correctly."

    # Only reload zsh if run in an interactive session
    [[ ! -o interactive ]] || _xeta::reload
}

function _xeta::theme::use {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[theme][23m


EOF
        return 1
    }

    # Respect compatibility with old lookup order
    if [[ -f "$XCUSTOM/$1.zsh-theme" ]]; then
        source "$XCUSTOM/$1.zsh-theme"
    elif [[ -f "$XCUSTOM/themes/$1.zsh-theme" ]]; then
        source "$XCUSTOM/themes/$1.zsh-theme"
    elif [[ -f "$XTHEMES/$1.zsh-theme" ]]; then
        source "$XTHEMES/$1.zsh-theme"
    else
        _xeta::log error "%B$1%b theme not found"
        return 1
    fi

    # Update theme settings
    XTHEME="$1"
    [[ $1 = random ]] || unset RANDOM_THEME
}

function _xeta::theme::lsfav {
    FAVLIST="$XCONFIG/theme-favlist.conf"
    io::notify "Your current favorites list:${reset_color}"
    cat "$FAVLIST"
    echo 
}

function _xeta::theme::fav {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[theme1 ...][23m


EOF
        return 1
    }
    FAVLIST="$XCONFIG/theme-favlist.conf"
    THEME=$1
    THEME_NAME="$THEME.zsh-theme"

    function insert_favlist() {
        if grep -q "$THEME_NAME" "$FAVLIST" 2> /dev/null; then
            echo "Already in favlist\n"
        else
            echo "$THEME_NAME" >> "$FAVLIST"
            echo "Saved to favlist\n"
        fi

    }
    io::yesno "Add $THEME to your favorites?" && insert_favlist "$THEME"
}

function _xeta::theme::unfav {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[theme1 ...][23m


EOF
        return 1
    }
    FAVLIST="$XCONFIG/theme-favlist.conf"
    THEME="$1.zsh-theme"
    if grep -q "$THEME" "$FAVLIST"; then
        io::yesno "Are you sure you want to remove $THEME from your favorites?" && sed -i "/$THEME/d" "$FAVLIST"
    fi
    echo
}

function _xeta::aliases {

    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF
    
    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04mlist[24m                          List all defined aliases
    [04madd[24m           [03m[alias_name][23m    Define a new alias
    [04mremove[24m        [03m[alias_name][23m    Remove a defined alias
    [04mcmd_for[24m       [03m[alias_name][23m    Get the command for an alias name
    [04mname_for[24m      [03m[command][23m       Get the alias name for a command
    [04mcontaining[24m    [03m[string][23m        Get all aliases containing a string


EOF
        return 1
    }

    local command="$1"
    shift

    $0::$command "$@"
}

function _xeta::aliases::list {
    if [[ -f "${XCONFIG}/aliases.conf" ]]; then
        
        io::notify "All currently defined aliases:\n"
        echo -e "--------------------------------------------------------"
        echo -e "${reset_color}$(alias)"
        echo -e "${fg[cyan]}--------------------------------------------------------${reset_color}"
    fi
}

function _xeta::aliases::add {
    
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[alias_name][23m


EOF
        return 1
    }
    
    echo "alias $1=\"$2\"" >> "$XCONFIG/aliases.conf" && io::notify "Alias saved."
    echo
}

function _xeta::aliases::remove {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[alias_name][23m


EOF
        return 1
    }
    io::notify "This only removes the alias for the current session.\nIf you want to remove it permanently you'll have to do it manually for now.\nIn the future I will include an option to permanently remove the alias from the cli.\n\n${reset_color}"
    local choice="$1"
    alias | grep $choice
    exit_code=$? # 0 = exists; 1 = does not exist;
    if [[ $exit_code == "0" ]]; then
        alias_line="$(alias | grep $choice)"
        alias_name=$(echo "$alias_line" | awk -F"'" '{print $1}')
        proper_alias_name="${alias_name%?}"
        unalias $proper_alias_name
        io::notify "Alias has been removed."
        return 0
    elif [[ $exit_code == "1" ]]; then
        io::notify "The alias you provided doesn't seem to exist. Maybe check your aliases file for the spelling?"
        return 1
    fi
}

function _xeta::aliases::cmd_for {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[alias_name][23m


EOF
        return 1
    }
    (( $+aliases[$1] )) && {
        io::notify "${reset_color}The following alias was found:\n"
        io::notify "${reset_color}$aliases[$1]"
        echo 
    } || io::notify "${reset_color}$1 isn't a defined alias!"
}

function _xeta::aliases::name_for {  
    # Use this if you remember the command but not the alias name.
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m


EOF
        return 1
    }
    function alias_finder() {
        local cmd="" exact="" longer="" wordStart="" wordEnd="" multiWordEnd=""
        for i in $@; do
            case $i in
                -e|--exact) 
                    exact=true
                ;;
                -l|--longer) 
                    longer=true
                ;;
                *)
                    if [[ -z $cmd ]]; then
                        cmd=$i
                    else
                        cmd="$cmd $i"
                    fi
                ;;
            esac
        done
        cmd=$(sed 's/[].\|$(){}?+*^[]/\\&/g' <<< $cmd) # adds escaping for grep
        if (( $(wc -l <<< $cmd) == 1 )); then
            while [[ $cmd != "" ]]; do
            if [[ $longer = true ]]; then
                wordStart="'{0,1}"
            else
                wordEnd="$"
                multiWordEnd="'$"
            fi
            if [[ $cmd == *" "* ]]; then
                local finder="'$cmd$multiWordEnd"
            else
                local finder=$wordStart$cmd$wordEnd
            fi
            alias | grep -E "=$finder"
            if [[ $exact = true || $longer = true ]]; then
                break
            else
                cmd=$(sed -E 's/ {0,1}[^ ]*$//' <<< $cmd) # removes last word
            fi
            done
        fi
        }

        preexec_alias_finder() {
            if [[ $ZSH_ALIAS_FINDER_AUTOMATIC = true ]]; then
                alias_finder $1
            fi
        }

        autoload -U add-zsh-hook
        add-zsh-hook preexec preexec_alias_finder

        alias_finder "$1" 
} 

function _xeta::aliases::containing {  
    # Use this if you don't remember which alias/es a command belongs to.
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[string][23m


EOF
        return 1
    }
    eval '
    function acs(){
        (( $+commands[python3] )) || { 
        echo "[error] No python executable detected"
        return
        }
        alias | python3 "'"${XDEPS}"'/aliases/cheatsheet.py" "$@"
    }
    '
    acs "$1"
}

function _xeta::util {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04mextract[24m    [03m[archive][23m    Extract archived files


EOF
        return 1
    }
    local command="$1"
    shift

    $0::$command "$@"
}

function _xeta::util::extract {

    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[file][23m


EOF
        return 1
    }
    setopt localoptions noautopushd
    local remove_archive=1
    if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
        remove_archive=0
        shift
    fi

    local pwd="$PWD"
    while (( $# > 0 )); do
        if [[ ! -f "$1" ]]; then
            echo "extract: '$1' is not a valid file" >&2
            shift
            continue
        fi

        local success=0
        local extract_dir="${1:t:r}"
        local file="$1" full_path="${1:A}"

        # Create an extraction directory based on the file name
        command mkdir -p "$extract_dir"
        builtin cd -q "$extract_dir"

        case "${file:l}" in
            (*.tar.gz|*.tgz)
                (( $+commands[pigz] )) && { 
                    tar -I pigz -xvf "$full_path" 
                } || tar zxvf "$full_path" 
            ;;
            (*.tar.bz2|*.tbz|*.tbz2)
                (( $+commands[pbzip2] )) && { 
                    tar -I pbzip2 -xvf "$full_path" 
                } || tar xvjf "$full_path" 
            ;;
            (*.tar.xz|*.txz)
                (( $+commands[pixz] )) && { 
                    tar -I pixz -xvf "$full_path" 
                } || {
                    tar --xz --help &> /dev/null && tar --xz -xvf "$full_path" || xzcat "$full_path" | tar xvf - 
                } 
            ;;
            (*.tar.zma|*.tlz)
                tar --lzma --help &> /dev/null && tar --lzma -xvf "$full_path" || lzcat "$full_path" | tar xvf - 
            ;;
            (*.tar.zst|*.tzst)
                tar --zstd --help &> /dev/null && tar --zstd -xvf "$full_path" || zstdcat "$full_path" | tar xvf - 
            ;;
            (*.tar) 
                tar xvf "$full_path" 
            ;;
            (*.tar.lz) 
                (( $+commands[lzip] )) && tar xvf "$full_path" 
            ;;
            (*.tar.lz4) 
                lz4 -c -d "$full_path" | tar xvf - 
            ;;
            (*.tar.lrz) 
                (( $+commands[lrzuntar] )) && lrzuntar "$full_path" 
            ;;
            (*.gz) 
                (( $+commands[pigz] )) && pigz -dk "$full_path" || gunzip -k "$full_path" 
            ;;
            (*.bz2) 
                bunzip2 "$full_path" 
            ;;
            (*.xz) 
                unxz "$full_path" 
            ;;
            (*.lrz) 
                (( $+commands[lrunzip] )) && lrunzip "$full_path" 
            ;;
            (*.lz4) 
                lz4 -d "$full_path" 
            ;;
            (*.lzma) 
                unlzma "$full_path" 
            ;;
            (*.z) 
                uncompress "$full_path" 
            ;;
            (*.zip|*.war|*.jar|*.ear|*.sublime-package|*.ipa|*.ipsw|*.xpi|*.apk|*.aar|*.whl) 
                unzip "$full_path" 
            ;;
            (*.rar) 
                unrar x -ad "$full_path" 
            ;;
            (*.rpm)
                rpm2cpio "$full_path" | cpio --quiet -id 
            ;;
            (*.7z) 
                7za x "$full_path" 
            ;;
            (*.deb)
                command mkdir -p "control" "data"
                ar vx "$full_path" > /dev/null
                builtin cd -q control; extract ../control.tar.*
                builtin cd -q ../data; extract ../data.tar.*
                builtin cd -q ..; command rm *.tar.* debian-binary 
            ;;
            (*.zst) 
                unzstd "$full_path" 
            ;;
            (*.cab) 
                cabextract "$full_path" 
            ;;
            (*.cpio|*.obscpio) 
                cpio -idmvF "$full_path" 
            ;;
            (*.zpaq) 
                zpaq x "$full_path" 
            ;;
            (*)
                echo "extract: '$file' cannot be extracted" >&2
                success=1 ;;
        esac

        (( success = success > 0 ? success : $? ))
        (( success == 0 && remove_archive == 0 )) && command rm "$full_path"
        shift

        # Go back to original working directory
        builtin cd -q "$pwd"

        # If content of extract dir is a single directory, move its contents up
        # Glob flags:
        # - D: include files starting with .
        # - N: no error if directory is empty
        # - Y2: at most give 2 files
        local -a content
        content=("${extract_dir}"/*(DNY2))
        if [[ ${#content} -eq 1 && -d "${content[1]}" ]]; then
        # The extracted folder (${content[1]}) may have the same name as $extract_dir
        # If so, we need to rename it to avoid conflicts in a 3-step process
        #
        # 1. Move and rename the extracted folder to a temporary random name
        # 2. Delete the empty folder
        # 3. Rename the extracted folder to the original name
            if [[ "${content[1]:t}" == "$extract_dir" ]]; then
                # =(:) gives /tmp/zsh<random>, with :t it gives zsh<random>
                local tmp_dir==(:); tmp_dir="${tmp_dir:t}"
                command mv -f "${content[1]}" "$tmp_dir" && command rmdir "$extract_dir" && command mv -f "$tmp_dir" "$extract_dir"
            else
                command mv -f "${content[1]}" . && command rmdir "$extract_dir"
            fi
        elif [[ ${#content} -eq 0 ]]; then
            command rmdir "$extract_dir"
        fi
    done
}

function _xeta::edit {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04mzshrc[24m         Edit your [03m.zshrc[23m file
    [04mbashrc[24m        Edit your [03m.bashrc[23m file
    [04mfavs[24m          Edit your [03mtheme-favlist.conf[23m file
    [04mconfig[24m        Edit your [03mxeta.conf[23m file
    [04maliases[24m       Edit your [03maliases.conf[23m file
    [04mglobals[24m       Edit your [03mglobals.conf[23m file
    [04mkeybinds[24m      Edit your [03mkey-binds.conf[23m file
    [04mjumppoints[24m    Edit your [03mjump-points.conf[23m
    [04mpath[24m          Edit your [03mpath.conf[23m file


EOF
        return 1
    }
    local command="$1"
    shift

    $0::$command "$@"
}

function _xeta::edit::zshrc {   
    if [[ "$SUDO" == "true" ]]; then
        sudo nano "${HOME}/.zshrc"
        return 0
    fi
    nano "${HOME}/.zshrc"
}

function _xeta::edit::bashrc {
    if [[ "$SUDO" == "true" ]]; then
        sudo nano "${HOME}/.bashrc"
        return 0
    fi
    nano "${HOME}/.bashrc"
}

function _xeta::edit::favs {
    if [[ "$SUDO" == "true" ]]; then
        sudo nano "${XCONFIG}/theme-favlist.conf"
        return 0
    fi
    nano "${XCONFIG}/theme-favlist.conf"
}

function _xeta::edit::config {
    if [[ "$SUDO" == "true" ]]; then
        sudo nano "${XCONFIG}/xeta.conf"
        return 0
    fi
    nano "${XCONFIG}/xeta.conf"
}

function _xeta::edit::aliases {
    if [[ "$SUDO" == "true" ]]; then
        sudo nano "${XCONFIG}/aliases.conf"
        return 0
    fi
    nano "${XCONFIG}/aliases.conf"
}

function _xeta::edit::globals {
    if [[ "$SUDO" == "true" ]]; then
        sudo nano "${XCONFIG}/globals.conf"
        return 0
    fi
    nano "${XCONFIG}/globals.conf"
}

function _xeta::edit::keybinds {
    if [[ "$SUDO" == "true" ]]; then
        sudo nano "${XCONFIG}/key-binds.conf"
        return 0
    fi
    nano "${XCONFIG}/key-binds.conf"
}

function _xeta::edit::jumppoints {
    if [[ "$SUDO" == "true" ]]; then
        sudo nano "${XCONFIG}/jump-points.conf"
        return 0
    fi
    nano "${XCONFIG}/jump-points.conf"
}

function _xeta::edit::path {
    if [[ "$SUDO" == "true" ]]; then
        sudo nano "${XCONFIG}/path.conf"
        return 0
    fi
    nano "${XCONFIG}/path.conf"
}

function _xeta::stats {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04mcmds[24m     Stats on the top 20 most used commands


EOF
        return 1
    }
    local command="$1"
    shift

    $0::$command "$@"
}

function _xeta::stats::cmds {   
    io::notify "The top 20 most commands${reset_color}"
    fc -l 1 \
    | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]*100/count "% " a }' \
    | grep -v "./" | sort -nr | head -n 20 | column -c3 -s " " -t | nl
    echo 
}

function _xeta::git {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04mstatus[24m                 View the current status of a repository
    [04mcommit[24m    [03m[command][23m    Manage commits in the current repository


EOF
        return 1
    }
    local command="$1"
    shift

    $0::$command "$@"
}

function _xeta::git::status { 
    STATUS="$(
        gitstatus_start MY
        gitstatus_query -d $PWD MY
        typeset -m 'VCS_STATUS_*'    
    )"
    if [[ "$STATUS" == "VCS_STATUS_RESULT=norepo-sync" ]]; then
        io::notify "
 No repository detected @:${reset_color}${PWD}\033[1;36m
 Status: ${reset_color}
 $STATUS"
        echo
    else
        io::notify "
 Repository @:${reset_color}${PWD}\033[1;36m
 Status: ${reset_color}
 $STATUS"
        echo
    fi
}

function _xeta::git::commit {
    
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    all                        Commit all changes
    specific   [03m[file1 ...][23m     Commit specific files


EOF
        return 1
    }
    local command="$1"
    shift

    $0::$command "$@"
}

function _xeta::git::commit::all {
    _type="$1"
    _msg="$2"
    if [[ -z "$_msg" || -z "$_type" ]]; then 
        echo >&2 "Usage: ${(j: :)${(s.::.)0#_}} [03m[msg][23m [03m[type][23m"   
        return 1 
    fi
    
    echo "type: $_type"
    echo "msg: $_msg"
    git add . || {io::err "Error adding files!"; return 1;}
    git commit -m "[${_type}] $_msg" || {io::err "Commit was unsuccessfull!"; return 1;}
    io::notify "Commit was successful!"    
}

function _xeta::git::commit::specific {
    if [[ -z "$_msg" || -z "$_type" ]]; then 
        echo >&2 "Usage: ${(j: :)${(s.::.)0#_}} [03m[msg][23m [03m[type][23m [03m[file1 ...][23m"   
        return 1 
    fi
    _type="$1"
    _msg="$2" 
    shift 2
    files=(${@})
    if [[ -n "$files" || -z "$files" ]]; then 
        echo >&2 "Usage: ${(j: :)${(s.::.)0#_}} [03m[msg][23m [03m[type][23m"   
        return 1 
    fi

    git add "${files}" || { io::err "Error adding files!"; return 1;}
    git commit -m "[${_type}] $_msg" || {io::err "Commit was unsuccessfull!"; return 1;}
    io::notify "Commit was successful!"
}

function _xeta::user {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04musername[24m    [03m[command][23m     Manage your username
    [04mpassword[24m    [03m[command][23m     Manage your password
    [04mpin[24m         [03m[command][23m     Manage your pin
    [04memail[24m       [03m[command][23m     Manage your email


EOF
        return 1
    }
}

function _xeta::user::username {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04mset[24m     [03m[pin][23m     Set your username
    [04munset[24m   [03m[pin][23m     Clear your saved username


EOF
        return 1
    }
}

function _xeta::user::username::set {
    cf="$XCONFIG/credentials.conf"

}

function _xeta::user::username::unset {
    cf="$XCONFIG/credentials.conf"
}

function _xeta::user::password {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04mset[24m     [03m[password][23m      Set your password
    [04munset[24m   [03m[password][23m      Clear your saved password


EOF
        return 1
    }
}

function _xeta::user::password::set {
    cf="$XCONFIG/credentials.conf"
}

function _xeta::user::password::unset {
    cf="$XCONFIG/credentials.conf"
}

function _xeta::user::pin {
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04mset[24m     [03m[pin][23m      Set your pin
    [04munset[24m   [03m[pin][23m      Clear your saved pin


EOF
        return 1
    }
}

function _xeta::user::pin::set {
    cf="$XCONFIG/credentials.conf"
    current_pin="$_PIN"
    good_pin="false"
    
}

function _xeta::user::pin::unset {
    cf="$XCONFIG/credentials.conf"   
}

function _xeta::user::email { 
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04mset[24m     [03m[email][23m      Set your email
    [04munset[24m   [03m[email][23m      Clear your saved email


EOF
        return 1
    }    
}

function _xeta::user::email::set {
    cf="$XCONFIG/credentials.conf"
}

function _xeta::user::email::unset {
    cf="$XCONFIG/credentials.conf"
}

function _xeta::toggle {    
    (( $# > 0 && $+functions[$0::$1] )) || {
        cat >&2 <<EOF

    [04mUsage[24m: ${(j: :)${(s.::.)0#_}} [03m[command][23m

    [04mAvailable commands[24m:

    [04msudo[24m    Toggle automatic sudo commands


EOF
        return 1
    }    
}

function _xeta::toggle::sudo {
    echo "hello sudo"
    _toggle_sudo_variable
    toggle_use_zsh_hooks_variable
    if [[ $SUDO == 'true' ]]; then 
        io::notify "Automatic sudo commands are off"; 
        return 0;
    elif [[ $SUDO == 'false' ]]; then 
        io::notify "Automatic sudo commands are on"; 
        return 0;
    fi
}   
