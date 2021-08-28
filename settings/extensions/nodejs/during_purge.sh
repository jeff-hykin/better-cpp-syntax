if [ -d "$PROJECTR_FOLDER" ]
then
    # delete node_modules
    "$PROJECTR_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$PROJECTR_FOLDER/node_modules"
    # .npm 
    "$PROJECTR_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$PROJECTR_HOME/.npm"
    # npmrc
    "$PROJECTR_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$PROJECTR_HOME/.npmrc"
fi