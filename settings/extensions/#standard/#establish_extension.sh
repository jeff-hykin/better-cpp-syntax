#!/usr/bin/env bash

# create extension-linker as a helper
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

# default to allowing unfree
export NIXPKGS_ALLOW_UNFREE=1

# 
# connect during_purge
# 
mkdir -p "$FORNIX_FOLDER/settings/.cache/"
mkdir -p "$FORNIX_FOLDER/settings/during_purge/"
mkdir -p "$FORNIX_FOLDER/settings/during_clean/"

# 
# connect during_start/during_manual_start
# 
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/tools/fornix/ensure_all_commands_executable" "$FORNIX_FOLDER/settings/during_start/081_000__ensure_all_commands_executable__.sh"
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/tools/fornix/ensure_all_commands_executable" "$FORNIX_FOLDER/settings/during_manual_start/081_000__ensure_all_commands_executable__.sh"

# 
# connect commands
# 
# ensure commands folder exists
if ! [[ -d "$FORNIX_COMMANDS_FOLDER" ]]; then
    # remove a potenial file
    rm -f "$FORNIX_COMMANDS_FOLDER"
    # make the folder
    mkdir -p "$FORNIX_COMMANDS_FOLDER"
fi
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/tools/fornix"      "$FORNIX_COMMANDS_FOLDER/tools/fornix"
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/tools/string"      "$FORNIX_COMMANDS_FOLDER/tools/string"
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/tools/file_system" "$FORNIX_COMMANDS_FOLDER/tools/file_system"

# 
# flush broken symlinks (for when extensions are changed/removed)
# 
for_each_item_in="$FORNIX_COMMANDS_FOLDER"; [ -z "$__NESTED_WHILE_COUNTER" ] && __NESTED_WHILE_COUNTER=0;__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER + 1))"; trap 'rm -rf "$__temp_var__temp_folder"' EXIT; __temp_var__temp_folder="$(mktemp -d)"; mkfifo "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER"; (find "$for_each_item_in" -xtype l -print0 2>/dev/null | sort -z > "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER" &); while read -d $'\0' each
do
    rm -f "$each" 2>/dev/null
done < "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER";__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER - 1))"

for_each_item_in="$FORNIX_FOLDER/during_start"; [ -z "$__NESTED_WHILE_COUNTER" ] && __NESTED_WHILE_COUNTER=0;__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER + 1))"; trap 'rm -rf "$__temp_var__temp_folder"' EXIT; __temp_var__temp_folder="$(mktemp -d)"; mkfifo "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER"; (find "$for_each_item_in" -xtype l -print0 2>/dev/null | sort -z > "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER" &); while read -d $'\0' each
do
    rm -f "$each" 2>/dev/null
done < "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER";__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER - 1))"

for_each_item_in="$FORNIX_FOLDER/during_start_prep"; [ -z "$__NESTED_WHILE_COUNTER" ] && __NESTED_WHILE_COUNTER=0;__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER + 1))"; trap 'rm -rf "$__temp_var__temp_folder"' EXIT; __temp_var__temp_folder="$(mktemp -d)"; mkfifo "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER"; (find "$for_each_item_in" -xtype l -print0 2>/dev/null | sort -z > "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER" &); while read -d $'\0' each
do
    rm -f "$each" 2>/dev/null
done < "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER";__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER - 1))"

for_each_item_in="$FORNIX_FOLDER/during_manual_start"; [ -z "$__NESTED_WHILE_COUNTER" ] && __NESTED_WHILE_COUNTER=0;__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER + 1))"; trap 'rm -rf "$__temp_var__temp_folder"' EXIT; __temp_var__temp_folder="$(mktemp -d)"; mkfifo "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER"; (find "$for_each_item_in" -xtype l -print0 2>/dev/null | sort -z > "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER" &); while read -d $'\0' each
do
    rm -f "$each" 2>/dev/null
done < "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER";__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER - 1))"

for_each_item_in="$FORNIX_FOLDER/during_clean"; [ -z "$__NESTED_WHILE_COUNTER" ] && __NESTED_WHILE_COUNTER=0;__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER + 1))"; trap 'rm -rf "$__temp_var__temp_folder"' EXIT; __temp_var__temp_folder="$(mktemp -d)"; mkfifo "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER"; (find "$for_each_item_in" -xtype l -print0 2>/dev/null | sort -z > "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER" &); while read -d $'\0' each
do
    rm -f "$each" 2>/dev/null
done < "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER";__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER - 1))"

for_each_item_in="$FORNIX_FOLDER/during_purge"; [ -z "$__NESTED_WHILE_COUNTER" ] && __NESTED_WHILE_COUNTER=0;__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER + 1))"; trap 'rm -rf "$__temp_var__temp_folder"' EXIT; __temp_var__temp_folder="$(mktemp -d)"; mkfifo "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER"; (find "$for_each_item_in" -xtype l -print0 2>/dev/null | sort -z > "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER" &); while read -d $'\0' each
do
    rm -f "$each" 2>/dev/null
done < "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER";__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER - 1))"

for_each_item_in="$FORNIX_FOLDER/requirements"; [ -z "$__NESTED_WHILE_COUNTER" ] && __NESTED_WHILE_COUNTER=0;__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER + 1))"; trap 'rm -rf "$__temp_var__temp_folder"' EXIT; __temp_var__temp_folder="$(mktemp -d)"; mkfifo "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER"; (find "$for_each_item_in" -xtype l -print0 2>/dev/null | sort -z > "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER" &); while read -d $'\0' each
do
    rm -f "$each" 2>/dev/null
done < "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER";__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER - 1))"



