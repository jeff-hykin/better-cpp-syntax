# if PROJECTR_FOLDER is not set, then assume the current folder
if [[ -z "$PROJECTR_FOLDER" ]]
then
    "$PROJECTR_COMMANDS_FOLDER/tools/python/check_pip_modules"
fi