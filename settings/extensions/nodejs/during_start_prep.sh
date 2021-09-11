# if inside start-prep
if [ "$HOME" != "$FORNIX_HOME" ]
then
    # system link into project home
    __temp_var__which_item=".pnpm-store"

    # if it doesn't exist in the home folder
    if ! [ -e "$HOME/$__temp_var__which_item" ]
    then
        # create the folder
        mkdir -p "$HOME/$__temp_var__which_item"
    fi
    # remove the existing
    rm -f "$FORNIX_HOME/$__temp_var__which_item" 2>/dev/null
    rm -rf "$FORNIX_HOME/$__temp_var__which_item" 2>/dev/null
    # then link it
    ln -s "$HOME/$__temp_var__which_item" "$FORNIX_HOME/$__temp_var__which_item"
    # make sure to ignore it
    "$FORNIX_FOLDER/settings/extensions/git/commands/ignore" "$FORNIX_HOME/$__temp_var__which_item"

    unset __temp_var__which_item
fi
