# XETA CLI v1.0.0

***Available commands as of version 1.0.0***

- [Utility commands](#utility_commands)
  - [xeta::confirm](#xeta_confirm)
  - [xeta::log](#xeta_log)
- [User Commands](#user_commands)
  - [xeta](#xeta)
  - [xeta::help](#xeta_help)
  - [xeta::credits](#xeta_credits)
  - [xeta::version](#xeta_version)
  - [xeta::reload](#xeta_reload)
  - [xeta::update](#xeta_update)
  - [xeta::backup](#xeta_backup)
  - [xeta::uninstall](#xeta_uninstall)
  - [xeta::changelog](#xeta_changelog)
  - [xeta::pr](#xeta_pr)
    - [xeta::pr::clean](#xeta_pr_clean)
    - [xeta::pr::test](#xeta_pr_test)
  - [xeta::plugin](#xeta_plugin)
    - [xeta::plugin::disable](#xeta_plugin_disable)
    - [xeta::plugin::enable](#xeta_plugin_enable)
    - [xeta::plugin::info](#xeta_plugin_info)
    - [xeta::plugin::list](#xeta_plugin_list)
    - [xeta::plugin::load](#xeta_plugin_load)
    - [xeta::plugin::path](#xeta_plugin_path)
    - [xeta::plugin::remove](#xeta_plugin_remove)
    - [xeta::plugin::update](#xeta_plugin_update)
  - [xeta::theme](xeta_theme)
    - [xeta::theme::list](#xeta_theme_list)
    - [xeta::theme::preview](#xeta_theme_preview)
    - [xeta::theme::previews](#xeta_theme_previews)
    - [xeta::theme::set](#xeta_theme_set)
    - [xeta::theme::use](#xeta_theme_use)
    - [xeta::theme::fav](#xeta_theme_fav)
    - [xeta::theme::unfav](#xeta_theme_unfav)
    - [xeta::theme::lsfav](#xeta_theme_lsfav)
  - [xeta::aliases](#xeta_aliases)
    - [xeta::aliases::list](#xeta_aliases_list)
    - [xeta::aliases_add](#xeta_aliases_add)
    - [xeta::aliases::remove](#xeta_aliases_remove)
    - [xeta::aliases::cmd_for](#xeta_aliases_cmd_for)
    - [xeta::aliases::name_for](#xeta_aliases_name_for)
    - [xeta::aliases::containing](#xeta_aliases_containing)
  - [xeta::util](#xeta_util)
    - [xeta::util::extract](#xeta_util_extract)
  - [xeta::edit](#xeta_edit)
    - [xeta::edit::zshrc](#xeta_edit_zshrc)
    - [xeta::edit::bashrc](#xeta_edit_bashrc)
    - [xeta::edit::favs](#xeta_edit_favs)
    - [xeta::edit::config](#xeta_edit_config)
    - [xeta::edit::aliases](#xeta_edit_aliases)
    - [xeta::edit::globals](#xeta_edit_globals)
    - [xeta::edit::keybinds](#xeta_edit_keybinds)
    - [xeta::edit::jumppoints](#xeta_edit_jumppoints)
    - [xeta::edit::path](#xeta_edit_path)
  - [xeta::stats](#xeta_stats)
    - [xeta::stats::cmds](#xeta_stats_cmds)
  - [xeta::git](#xeta_git)
    - [xeta::git::status](#xeta_git_status)
    - [xeta::git_commit](#xeta_git_commit)
      - [xeta::git::commit::all](#xeta_git_commit_all)
      - [xeta::git::commit::specific](#xeta_git_commit_specific)
  - [xeta::user](#xeta_user)
    - [xeta::user::pin](#xeta_user_pin)
      - [xeta::user::pin::reset](#xeta_user_pin_reset)
  - [xeta::toggle](#xeta_toggle)
    - [xeta::toggle::sudo](#xeta_toggle_sudo)

---

## [Utility commands](#utility_commands)

> Utility functions used by the cli.

### [xeta::confirm](#xeta_confirm)

- If supplied a question it will ask it and read the answer

### [xeta::log](#xeta_log)

- Writes to the log file in logs/

---

## [User facing commands](#user_commands)

> Commands available for the user to use.
 
### [xeta](#xeta)

- If called with no follow up commands it defaults to xeta::help.

### [xeta::help](#xeta_help)

- Prints help information such as available commands.

### [xeta::credits](#xeta_credits)

- Prints credit and thanks to the authors of the technologies used in this project.

### [xeta::version](#xeta_version)

- Returns the current version of Xeta

### [xeta::reload](#xeta_reload)

- Reloads the current Zsh session inturn reloads Xeta

### [xeta::update](#xeta_update)

- Checks for the latest version of Xeta and updates or not accordingly

### [xeta::backup](#xeta_backup)

- Creates and archives a copy of Xeta and its current configuration.

### [xeta::uninstall](#xeta_uninstall)

- Uninstalls Xeta and optionally makes a backup

### [xeta::changelog](#xeta_changelog)

- Displays and saves the latest changes on the current branch.

### [xeta::pr](#xeta_pr)

- If called with no follow up commands it prints a usage message

### [xeta::pr::clean](#xeta_pr_clean)

- Deletes any existing pull request branches

### [xeta::pr::test](#xeta_pr_test)

- Test a pull request and optionally roll back changes

### [xeta::plugin](#xeta_plugin)

- If called with no follow up commands it prints a usage message

### [xeta::plugin::disable](#xeta_plugin_disable)

- Disables a plugin(s) by removing it from the plugins array in xeta.conf

### [xeta::plugin::enable](#xeta_plugin_enable)

- Eables a plugin(s) by adding it to the plugins array in xeta.conf

### [xeta::plugin::info](#xeta_plugin_info)

- Prints information about the specified plugin

### [xeta::plugin::list](#xeta_plugin_list)

- Lists all available plugins

### [xeta::plugin::load](#xeta_plugin_load)

- Loads the specified plugin(s) functions and completions

### [xeta::plugin::path](#xeta_plugin_path)

- Returns the absolute path to the plugin

### [xeta::plugin::remove](#xeta_plugin_remove)

- Permanently deletes a plugin(s) and removes it from the plugins array in xeta.conf

### [xeta::plugin::update](#xeta_plugin_update) (TODO: implement)

- Downloads updates a plugin(s) if there are any updates available 

### [xeta::theme](xeta_theme)

- If called with no follow up commands it prints a usage message

### [xeta::theme::list](#xeta_theme_list)

- List all available themes

### [xeta::theme::preview](#xeta_theme_preview)

- Preview a single specified theme

### [xeta::theme::previews](#xeta_theme_previews)

- Print a preview of all themes to the command line.

### [xeta::theme::set](#xeta_theme_set)

- Set a theme to remain persistant in your Xeta configuration file (xeta.conf)

### [xeta::theme::use](#xeta_theme_use)

- Use a theme just for the current session

### [xeta::theme::fav](#xeta_theme_fav)

- Add a favorite theme to your favorites list (theme-favlist.conf)

### [xeta::theme::unfav](#xeta_theme_unfav)

- Remove a favorite theme from your favorites list (theme-favlist.conf)

### [xeta::theme::lsfav](#xeta_theme_lsfav)

- List all themes in your favorites list (theme-favlist.conf)

### [xeta::aliases](#xeta_aliases)

- If called with no follow up commands it prints a usage message

### [xeta::aliases::list](#xeta_aliases_list)

- List all defined aliases

### [xeta::aliases::add](#xeta_aliases_add)

- Add an alias to aliases.conf

### [xeta::aliases::remove](#xeta_aliases_remove)

- Remove an alias from the current session and from aliases.conf

### [xeta::aliases::cmd_for](#xeta_aliases_cmd_for)

- Get the corresponding command for a specified alias name

### [xeta::aliases::name_for](#xeta_aliases_name_for)

- Get the corresponding alias name for a specified command

### [xeta::aliases::containing](#xeta_aliases_containing)

- Returns aliases containing the given word or command

### [xeta::util](#xeta_util)

- If called with no follow up commands it prints a usage message

### [xeta::util::extract](#xeta_util_extract)

- Extract over 10 different archive file types

### [xeta::edit](#xeta_edit)

- If called with no follow up commands it prints a usage message

### [xeta::edit::zshrc](#xeta_edit_zshrc)

- Edit your Zsh configuration file (.zshrc)

### [xeta::edit::bashrc](#xeta_edit_bashrc)

- Edit your Bash configuration file (.bashrc)

### [xeta::edit::favs](#xeta_edit_favs)

- Edit the favlist configuration file (theme-favlist.conf)

### [xeta::edit::config](#xeta_edit_config)

- Edit the Xeta configuration file (xeta.conf)

### [xeta::edit::aliases](#xeta_edit_aliases)

- Edit the aliases configuration file (aliases.conf)

### [xeta::edit::globals](#xeta_edit_globals)

- Edit the globals configuration file (globals.conf)

### [xeta::edit::keybinds](#xeta_edit_keybinds)

- Edit the key-binds configuration file (key-binds.conf)

### [xeta::edit::jumppoints](#xeta_edit_jumppoints)

- Edit the jump-points configuration file (jump-points.conf)

### [xeta::edit::path](#xeta_edit_path)

- Edit the path configuration file (path.conf)

### [xeta::stats](#xeta_stats)

- If called with no follow up commands it prints a usage message

### [xeta::stats::cmds](#xeta_stats_cmds)

- Prints stats on the top 20 most used commands

### [xeta::git](#xeta_git)

- If called with no follow up commands it prints a usage message

### [xeta::git::status](#xeta_git_status)

- Print the status of the currnt repository

### [xeta::git::commit](#xeta_git_commit)

- If called with no follow up commands it prints a usage message

### [xeta::git::commit::all](#xeta_git_commit_all)

- Commit all changes to the current branch

### [xeta::git::commit::specific](#xeta_git_commit_specific) (TODO: implement)

- Commit specific changes to te current branch

### [xeta::user](#xeta_user) (TODO: implement)

- If called with no follow up commands it prints a usage message

### [xeta::user::pin](#xeta_user_pin) (TODO: implement)

- If called with no follow up commands it prints the usage message

### [xeta::user::pin::reset](#xeta_user_pin_reset)

- Resets your pin

### [xeta::toggle](#xeta_toggle)

- If called with no follow up commands it prints a usage message

### [xeta::toggle::sudo](#xeta_toggle_sudo) (TODO: implement)

- Activate/Deactivate automatic sudo commands via $SUDO in xeta.conf
