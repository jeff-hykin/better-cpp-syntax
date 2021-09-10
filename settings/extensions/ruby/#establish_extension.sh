#!/usr/bin/env bash

# create extension-linker as a helper
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
        __temp_var__target_full_path="$FORNIX_FOLDER/settings/$target_file"
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
    __temp_var__path_from_target_to_local_file="$(realpath "$__THIS_FORNIX_EXTENSION_FOLDERPATH__" --relative-to="$(dirname "$__temp_var__target_full_path")" --canonicalize-missing)/$local_file"
    ln -s "$__temp_var__path_from_target_to_local_file" "$__temp_var__target_full_path"
    unset __temp_var__path_from_target_to_local_file
    
    unset local_file
    unset target_file
}

# 
# connect during_clean
# 
link_extension_file__to__ "during_clean.sh" "during_clean/801_ruby.sh"

# 
# connect during_purge
# 
link_extension_file__to__ "during_purge.sh" "during_purge/801_ruby.sh"

# 
# connect commands
# 
link_extension_file__to__ "commands" "$FORNIX_COMMANDS_FOLDER/tools/ruby"

# 
# connect during_start
# 
link_extension_file__to__ "during_start.sh" "during_start/033_000_ruby.sh"

# 
# connect during_start_prep
# 
link_extension_file__to__ "during_start_prep.sh" "during_start_prep/034_000_ruby.sh"