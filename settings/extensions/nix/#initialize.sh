export __PROJECTR_NIX_SETTINGS_PATH="$PROJECTR_FOLDER/settings/extensions/nix/settings.toml"
export __PROJECTR_NIX_MAIN_CODE_PATH="$PROJECTR_FOLDER/settings/extensions/nix/parse_dependencies.nix"
export __PROJECTR_NIX_PACKAGES_FILE_PATH="$PROJECTR_FOLDER/settings/requirements/nix.toml"
export __PROJECTR_NIX_PATH_EXPORT_FILE="$PROJECTR_FOLDER/settings/.cache/dependency_paths.dont-sync.json"
export __PROJECTR_NIX_COMMANDS="$PROJECTR_FOLDER/settings/extensions/nix/commands"

# 
# this is just a helper (common to most all extensions)
# 
link_extension_file__to__() {
    local_file="$1"
    target_file="$2"
    
    # check for absolute path, if not absolute make it relative to project/settings
    case "$target_file" in
        /*) __temp_var__is_absolute_path="true" ;;
        *) : ;;
    esac
    if ! [ "$__temp_var__is_absolute_path" = "true" ]
    then
        __temp_var__target_full_path="$PROJECTR_FOLDER/settings/$target_file"
    else
        __temp_var__target_full_path="$target_file"
    fi
    unset __temp_var__is_absolute_path
    
    # remove existing things in the way
    rm -f "$__temp_var__target_full_path" 2>/dev/null
    rm -rf "$__temp_var__target_full_path" 2>/dev/null
    # make sure parent folder exists
    mkdir -p "$(dirname "$__temp_var__target_full_path")"
    # link the file (relative link, which it what makes it complicated)
    __temp_var__path_from_target_to_local_file="$(realpath "$__THIS_PROJECTR_EXTENSION_FOLDERPATH__" --relative-to="$(dirname "$__temp_var__target_full_path")" --canonicalize-missing)/$local_file"
    ln -s "$__temp_var__path_from_target_to_local_file" "$__temp_var__target_full_path"
    unset __temp_var__path_from_target_to_local_file
    
    unset __temp_var__target_folder
    unset local_file
    unset automatic_setup_name
}

# 
# connect shell.nix
# 
link_extension_file__to__ "shell.nix" "requirements/shell.nix"

# 
# connect nix.toml
# 
link_extension_file__to__ "nix.toml" "requirements/nix.toml"

# 
# connect commands
# 
link_extension_file__to__ "commands" "$PROJECTR_COMMANDS_FOLDER/tools/nix"

# 
# connect when_cleaning
# 
link_extension_file__to__ "when_cleaning.sh" "when_cleaning/450_nix.sh"