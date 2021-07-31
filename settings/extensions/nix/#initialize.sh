export __PROJECTR_NIX_SETTINGS_PATH="$PROJECTR_FOLDER/settings/extensions/nix/settings.toml"
export __PROJECTR_NIX_MAIN_CODE_PATH="$PROJECTR_FOLDER/settings/extensions/nix/parse_dependencies.nix"
export __PROJECTR_NIX_PACKAGES_FILE_PATH="$PROJECTR_FOLDER/settings/requirements/nix.toml"
export __PROJECTR_NIX_PATH_EXPORT_FILE="$PROJECTR_FOLDER/settings/.cache/dependency_paths.dont-sync.json"
export __PROJECTR_NIX_COMMANDS="$PROJECTR_FOLDER/settings/extensions/nix/commands"


# 
# connect shell.nix
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/requirements/shell.nix" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/requirements/shell.nix" 2>/dev/null
# syslink local tools
ln -s "../extensions/nix/shell.nix" "$PROJECTR_FOLDER/settings/requirements/shell.nix"

# 
# connect nix.toml
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/requirements/nix.toml" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/requirements/nix.toml" 2>/dev/null
# syslink local tools
ln -s "../extensions/nix/nix.toml" "$PROJECTR_FOLDER/settings/requirements/nix.toml"

# 
# connect commands
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/commands/tools/nix" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/commands/tools/nix" 2>/dev/null
# syslink local tools
ln -s "../../settings/extensions/nix/commands" "$PROJECTR_FOLDER/commands/tools/nix"

# 
# connect when_cleaning
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/when_cleaning/450_nix.sh" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/when_cleaning/450_nix.sh" 2>/dev/null
# syslink when_cleaning
ln -s "../extensions/nix/when_cleaning.sh" "$PROJECTR_FOLDER/settings/when_cleaning/450_nix.sh"