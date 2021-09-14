# delete all the __pycache__'s
for item in $(find "$FORNIX_FOLDER" ! -path . -iregex '__pycache__')
do
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$item"
done

# remove the hashes
"$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$FORNIX_FOLDER/.cache/.pip_poetry_modules.cleanable.hash"
"$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$FORNIX_FOLDER/.cache/.pip_modules.cleanable.hash"