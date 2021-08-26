#!/usr/bin/env bash

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
# connect automatic_setup
# 
link_extension_file__to__ "commands/setup_venv" "automatic_setup/01900_setup_python_venv.sh"
link_extension_file__to__ "commands/add_project_to_pythonpath" "automatic_setup/02200_setup_pythonpath.sh"
link_extension_file__to__ "commands/ensure_pip_modules" "automatic_setup/02100_ensure_pip_modules.sh"
link_extension_file__to__ "commands/refresh_ignores" "automatic_setup/02400_python_ignores.sh"


# 
# connect manual_setup
# 
link_extension_file__to__ "commands/add_project_to_pythonpath" "automatic_setup/02200_setup_pythonpath.sh"
link_extension_file__to__ "commands/refresh_ignores" "automatic_setup/02400_python_ignores.sh"

# 
# connect when_cleaning
# 
link_extension_file__to__ "when_cleaning.sh" "when_cleaning/801_python.sh"

# 
# connect when_purging
# 
link_extension_file__to__ "when_purging.sh" "when_purging/802_remove_venv.sh"

# 
# connect commands
# 
link_extension_file__to__ "commands" "$PROJECTR_COMMANDS_FOLDER/tools/python"