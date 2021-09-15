#!/usr/bin/env bash

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
# connect during_clean
# 
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/during_clean.sh" "$FORNIX_FOLDER/settings/during_clean/804_nodejs.sh"

# 
# connect during_purge
# 
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/during_purge.sh" "$FORNIX_FOLDER/settings/during_purge/805_remove_node_modules.sh"

# 
# connect commands
# 
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands" "$FORNIX_COMMANDS_FOLDER/tools/nodejs"

# 
# connect pnpm store since its content-addressed storage
# 
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/during_start_prep.sh" "$FORNIX_FOLDER/settings/during_start_prep/032_000_link_pnpm_store.sh"