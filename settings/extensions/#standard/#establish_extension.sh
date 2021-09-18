#!/usr/bin/env bash

# default to allowing unfree
export NIXPKGS_ALLOW_UNFREE=1
relatively_link="$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/relative_link"

# 
# create basics
# 
mkdir -p "$FORNIX_FOLDER/settings/.cache/"
mkdir -p "$FORNIX_FOLDER/settings/during_purge/"
mkdir -p "$FORNIX_FOLDER/settings/during_clean/"

# 
# connect during_start/during_manual_start
# 
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/tools/fornix/ensure_all_commands_executable" "$FORNIX_FOLDER/settings/during_start/081_000__ensure_all_commands_executable__.sh"
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/tools/fornix/ensure_all_commands_executable" "$FORNIX_FOLDER/settings/during_manual_start/081_000__ensure_all_commands_executable__.sh"

# 
# connect commands
# 
# ensure commands folder exists
if ! [ -d "$FORNIX_COMMANDS_FOLDER" ]
then
    # remove a potenial file
    rm -f "$FORNIX_COMMANDS_FOLDER"
    # make the folder
    mkdir -p "$FORNIX_COMMANDS_FOLDER"
fi
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/tools/fornix"      "$FORNIX_COMMANDS_FOLDER/tools/fornix"
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/tools/string"      "$FORNIX_COMMANDS_FOLDER/tools/string"
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/tools/file_system" "$FORNIX_COMMANDS_FOLDER/tools/file_system"

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

unset relatively_link