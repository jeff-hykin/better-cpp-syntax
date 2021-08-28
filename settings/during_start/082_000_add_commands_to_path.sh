# add commands to path
PATH="$PROJECTR_COMMANDS_FOLDER:$PATH"

# if theres a help command
if [[ -f "$PROJECTR_COMMANDS_FOLDER/help" ]]; then
    # override the default bash "help"
    alias help="$PROJECTR_COMMANDS_FOLDER/help" 
fi