# ensure commands folder exists
if ! [[ -d "$PROJECTR_COMMANDS_FOLDER" ]]; then
    # remove a potenial file
    rm -f "$PROJECTR_COMMANDS_FOLDER"
    # make the folder
    mkdir -p "$PROJECTR_COMMANDS_FOLDER"
fi