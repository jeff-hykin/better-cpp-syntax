if [ -d "$PROJECTR_FOLDER" ]
then
    # delete node_modules
    "$PROJECTR_COMMANDS_FOLDER/tools/remove" "$PROJECTR_FOLDER/node_modules"
    # .npm 
    "$PROJECTR_COMMANDS_FOLDER/tools/remove" "$PROJECTR_HOME/.npm"
    # npmrc
    "$PROJECTR_COMMANDS_FOLDER/tools/remove" "$PROJECTR_HOME/.npmrc"
fi