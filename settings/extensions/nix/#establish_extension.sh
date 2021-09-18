export __FORNIX_NIX_SETTINGS_PATH="$FORNIX_FOLDER/settings/extensions/nix/settings.toml"
export __FORNIX_NIX_MAIN_CODE_PATH="$FORNIX_FOLDER/settings/extensions/nix/parse_dependencies.nix"
export __FORNIX_NIX_PACKAGES_FILE_PATH="$FORNIX_FOLDER/settings/requirements/system_tools.toml"
export __FORNIX_NIX_PATH_EXPORT_FILE="$FORNIX_FOLDER/settings/.cache/dependency_paths.do_not_sync.json"
export __FORNIX_NIX_COMMANDS="$FORNIX_FOLDER/settings/extensions/nix/commands"

# this is a helper
relatively_link="$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/relative_link"

# 
# connect shell.nix
# 
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/shell.nix" "$FORNIX_FOLDER/settings/requirements/advanced_system_tools.nix"

# 
# connect nix.toml
# 
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/nix.toml" "$FORNIX_FOLDER/settings/requirements/system_tools.toml"

# 
# connect commands
# 
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands" "$FORNIX_COMMANDS_FOLDER/tools/nix"

# 
# connect during_clean
# 
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/during_clean.sh" "$FORNIX_FOLDER/settings/during_clean/450_nix.sh"

# 
# connect during_start
# 
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/during_start.sh" "$FORNIX_FOLDER/settings/during_start/010_000__ssl_fix__.sh"

unset relatively_link