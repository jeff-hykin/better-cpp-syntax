if [ -d "$PROJECTR_FOLDER" ]
then
    # delete venv
    "$PROJECTR_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$PROJECTR_FOLDER/.venv"
    
    # if poetry exists
    if [ -n "$(command -v "poetry")" ]
    then
        # clear all the caches
        yes | poetry cache clear . --all
    fi
fi