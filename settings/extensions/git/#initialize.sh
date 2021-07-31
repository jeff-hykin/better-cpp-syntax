#!/usr/bin/env bash

# 
# connect when_cleaning
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/when_cleaning/500_git.sh" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/when_cleaning/500_git.sh" 2>/dev/null
# syslink when_cleaning
ln -s "../extensions/git/when_cleaning.sh" "$PROJECTR_FOLDER/settings/when_cleaning/500_git.sh"

# 
# config
# 
# if the project config exists
rm -f "$__DIR__/config"
if [[ -f "$PROJECTR_FOLDER/.git/config" ]]
then
    mkdir -p "$__DIR__"
    ln -s "../../../.git/config" "$__DIR__/config"
fi

# if there's no pull setting, then add it to the project
git config pull.rebase &>/dev/null || git config pull.ff &>/dev/null || git config --add pull.rebase false &>/dev/null

# 
# ignore
# 
mkdir -p "$PROJECTR_FOLDER/.git/info/"
# check if file exists
if [[ -f "$__DIR__/exclude.ignore" ]]
then
    rm -f "$PROJECTR_FOLDER/.git/info/exclude"
    ln "$__DIR__/exclude.ignore" "$PROJECTR_FOLDER/.git/info/exclude"
fi

# 
# hooks
#
__temp_var_githooks_folder="$__DIR__/hooks"
# if the folder exists
if [[ -d "$__temp_var_githooks_folder" ]]
then
    # iterate over the filess
    for dir in $(find "$__temp_var_githooks_folder" -maxdepth 1)
    do
        git_file="$PROJECTR_FOLDER/.git/hooks/$(basename "$dir")"
        # ensure all the git hook files exist
        touch "$git_file"
        # make sure each calls the hooks # FIXME: some single quotes in $dir probably need to be escaped here
        cat "$git_file" | grep "#START: projectr hooks" &>/dev/null || echo "
        #START: projectr hooks (don't delete unless you understand)
        if [ -n "'"$PROJECTR_FOLDER"'" ]
        then
            absolute_path () {
                "'
                echo "$(builtin cd "$(dirname "$1")"; pwd)/$(basename "$1")"
                '"
            }
            for hook in "'$'"(find "'"$PROJECTR_FOLDER"'"'/settings/extensions/git/hooks/$(basename "$dir")/' -maxdepth 1)
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
        #END: projectr hooks (don't delete unless you understand)
        " >> "$git_file"
        # ensure its executable
        chmod ugo+x "$git_file" &>/dev/null || sudo chmod ugo+x "$git_file"
    done
fi