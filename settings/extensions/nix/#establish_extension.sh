export __FORNIX_NIX_SETTINGS_PATH="$FORNIX_FOLDER/settings/extensions/nix/settings.toml"
export __FORNIX_NIX_MAIN_CODE_PATH="$FORNIX_FOLDER/settings/extensions/nix/parse_dependencies.nix"
export __FORNIX_NIX_PACKAGES_FILE_PATH="$FORNIX_FOLDER/settings/requirements/nix.toml"
export __FORNIX_NIX_PATH_EXPORT_FILE="$FORNIX_FOLDER/settings/.cache/dependency_paths.do_not_sync.json"
export __FORNIX_NIX_COMMANDS="$FORNIX_FOLDER/settings/extensions/nix/commands"

# 
# this is just a helper (common to most all extensions)
# 
relative_link__file_to__() {
    existing_filepath="$1"
    target_filepath="$2"
    
    # 
    # make existing_filepath absolute
    # 
    case "$existing_filepath" in
        # if absolute
        /*) : ;;
        # if relative
        *) existing_filepath="$FORNIX_FOLDER/$existing_filepath" ;;
    esac
    
    # 
    # make target_filepath absolute
    # 
    case "$target_filepath" in
        # if absolute
        /*) : ;;
        # if relative
        *) target_filepath="$FORNIX_FOLDER/$target_filepath" ;;
    esac
    
    # remove existing things in the way
    rm -f "$target_filepath" 2>/dev/null
    rm -rf "$target_filepath" 2>/dev/null
    # make sure parent folder exists
    mkdir -p "$(dirname "$target_filepath")"
    __temp_var__relative_part="$(realpath "$(dirname "$existing_filepath")" --relative-to="$(dirname "$target_filepath")" --canonicalize-missing)"
    __temp_var__relative_path="$__temp_var__relative_part/$(basename "$existing_filepath")"
    # link using the relative path
    if [ -d "$existing_filepath" ]
    then
        ln -s "$__temp_var__relative_path/" "$target_filepath"
    else
        ln -s "$__temp_var__relative_path" "$target_filepath"
    fi
    unset __temp_var__relative_path
    unset __temp_var__relative_part
    unset existing_filepath
    unset target_filepath
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
link_extension_file__to__ "commands" "$FORNIX_COMMANDS_FOLDER/tools/nix"

# 
# connect during_clean
# 
link_extension_file__to__ "during_clean.sh" "during_clean/450_nix.sh"

# 
# connect during_start
# 
link_extension_file__to__ "during_start.sh" "during_start/010_000__ssl_fix__.sh"