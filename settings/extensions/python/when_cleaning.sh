# delete all the __pycache__'s
for item in $(find "$PROJECTR_FOLDER" ! -path . -iregex '__pycache__')
do
    "$PROJECTR_COMMANDS_FOLDER/tools/remove" "$item"
done