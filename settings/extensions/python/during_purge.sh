if [ -d "$FORNIX_FOLDER" ]
then
    # delete venv
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$FORNIX_FOLDER/.venv"
    
    # if poetry exists
    if [ -n "$(command -v "poetry")" ]
    then
        # clear all the caches
        yes | poetry cache clear . --all
    fi
    
    # all the home folder junk from python and common pip modules
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$FORNIX_HOME/.cache/pip"
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$FORNIX_HOME/.local/share/virtualenv"
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$FORNIX_HOME/.config/pypoetry"
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$FORNIX_HOME/.config/matplotlib"
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$FORNIX_HOME/.ipython"
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$FORNIX_HOME/.jupyter"
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$FORNIX_HOME/.keras"
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$FORNIX_HOME/.local/share/jupyter"
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$FORNIX_HOME/.python_history"
fi