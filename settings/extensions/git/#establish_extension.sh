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
link_extension_file__to__ "during_clean.sh" "during_clean/500_git.sh"

# 
# connect during_start_prep
# 
link_extension_file__to__ "during_start_prep.sh" "during_start_prep/051_000_copy_git_config.sh"

# 
# connect commands
# 
link_extension_file__to__ "commands" "$FORNIX_COMMANDS_FOLDER/tools/git"

# 
# config
# 
# if the project config exists
rm -f "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/config"
if [[ -f "$FORNIX_FOLDER/.git/config" ]]
then
    mkdir -p "$__THIS_FORNIX_EXTENSION_FOLDERPATH__"
    ln -s "../../../.git/config" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/config"
fi

# always pay attention to case
git config core.ignorecase false

# if there's no pull setting, then add it to the project
git config pull.rebase &>/dev/null || git config pull.ff &>/dev/null || git config --add pull.rebase false &>/dev/null

# 
# ignore
# 
mkdir -p "$FORNIX_FOLDER/.git/info/"
# check if file exists
if [[ -f "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/exclude.ignore" ]]
then
    rm -f "$FORNIX_FOLDER/.git/info/exclude"
    ln "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/exclude.ignore" "$FORNIX_FOLDER/.git/info/exclude"
fi

# 
# hooks
#
__temp_var_githooks_folder="$__THIS_FORNIX_EXTENSION_FOLDERPATH__/hooks"
# if the folder exists
if [[ -d "$__temp_var_githooks_folder" ]]
then
    # iterate over the files
    for dir in $(find "$__temp_var_githooks_folder" -maxdepth 1)
    do
        git_file="$FORNIX_FOLDER/.git/hooks/$(basename "$dir")"
        # ensure all the git hook files exist
        mkdir -p "$(dirname "$git_file")"
        touch "$git_file"
        # make sure each calls the hooks # FIXME: some single quotes in $dir probably need to be escaped here
        cat "$git_file" | grep "#START: fornix hooks" &>/dev/null || echo "
        #START: fornix hooks (don't delete unless you understand)
        if [ -n "'"$FORNIX_FOLDER"'" ]
        then
            absolute_path () {
                "'
                echo "$(builtin cd "$(dirname "$1")"; pwd)/$(basename "$1")"
                '"
            }
            for hook in "'$'"(find "'"$FORNIX_FOLDER"'"'/settings/extensions/git/hooks/$(basename "$dir")/' -maxdepth 1)
            do
                # check if file exists
                if [ -f "'"$hook"'" ]
                then
                    hook="'"$(absolute_path "$hook")"'"
                    chmod ugo+x "'"'"\$hook"'"'" &>/dev/null || sudo chmod ugo+x "'"'"\$hook"'"'"
                    "'"'"\$hook"'"'" || echo "'"'"problem running: \$hook"'"'"
                fi
            done
        fi
        #END: fornix hooks (don't delete unless you understand)
        " >> "$git_file"
        # ensure its executable
        chmod ugo+x "$git_file" &>/dev/null || sudo chmod ugo+x "$git_file"
    done
fi

# 
# setup object sharing across repos
# 
if [ -d "$FORNIX_FOLDER/.git/objects" ]
then
    # 
    # add self to git_alternate_object_directories
    # 
    if [ "$HOME" != "$FORNIX_HOME" ]
    then
        # ensure the location exists
        mkdir -p "$HOME/.cache/git_alternate_object_directories"
        file_name="$(md5sum <<< "$FORNIX_FOLDER/.git/objects" | sed 's/ //g' | sed 's/-//g' )"
        # create or overwrite the objects
        printf '%s' "$FORNIX_FOLDER/.git/objects" > "$HOME/.cache/git_alternate_object_directories/$file_name"
        rm -f "$FORNIX_HOME/.cache/git_alternate_object_directories" 2>/dev/null
        rm -rf "$FORNIX_HOME/.cache/git_alternate_object_directories" 2>/dev/null
        ln -s "$HOME/.cache/git_alternate_object_directories" "$FORNIX_HOME/.cache/git_alternate_object_directories"
    fi
    
    # 
    # create the GIT_ALTERNATE_OBJECT_DIRECTORIES var if needed
    # 
    if [ -z "$GIT_ALTERNATE_OBJECT_DIRECTORIES" ]
    then
        # this loop is so stupidly complicated because of many inherent-to-shell reasons, for example: https://stackoverflow.com/questions/13726764/while-loop-subshell-dilemma-in-bash
        for_each_item_in="$FORNIX_HOME/.cache/git_alternate_object_directories"; [ -z "$__NESTED_WHILE_COUNTER" ] && __NESTED_WHILE_COUNTER=0;__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER + 1))"; trap 'rm -rf "$__temp_var__temp_folder"' EXIT; __temp_var__temp_folder="$(mktemp -d)"; mkfifo "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER"; (find "$for_each_item_in" -maxdepth 1 ! -path "$for_each_item_in" -print0 2>/dev/null | sort -z > "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER" &); while read -d $'\0' each
        do
            GIT_ALTERNATE_OBJECT_DIRECTORIES="$GIT_ALTERNATE_OBJECT_DIRECTORIES:$each"
        done < "$__temp_var__temp_folder/pipe_for_while_$__NESTED_WHILE_COUNTER";__NESTED_WHILE_COUNTER="$((__NESTED_WHILE_COUNTER - 1))"
    fi
    # export it
    export GIT_ALTERNATE_OBJECT_DIRECTORIES="$GIT_ALTERNATE_OBJECT_DIRECTORIES"
fi