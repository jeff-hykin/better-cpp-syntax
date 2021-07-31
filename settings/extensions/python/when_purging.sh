if [ -d "$PROJECTR_FOLDER" ]
then
    # delete venv
    "$PROJECTR_COMMANDS_FOLDER/tools/remove" "$PROJECTR_FOLDER/.venv"
fi