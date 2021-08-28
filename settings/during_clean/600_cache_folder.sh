# the usual things
__temp_var_cache_folder="$PROJECTR_FOLDER/settings/.cache"
"$PROJECTR_COMMANDS_FOLDER/tools/remove" "$__temp_var_cache_folder"
for item in $(find "$PROJECTR_FOLDER" ! -path . -iregex '.*\.cleanable(\..*)?')
do
    "$PROJECTR_COMMANDS_FOLDER/tools/remove" "$item"
done
# restore the keep file
mkdir -p "$__temp_var_cache_folder" && touch "$__temp_var_cache_folder/.keep"