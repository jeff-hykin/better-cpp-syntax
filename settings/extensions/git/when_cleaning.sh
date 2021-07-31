# remove git's hooks
if [[ -d "$PROJECTR_FOLDER/.git/hooks" ]]
then
    for file in $(find "$PROJECTR_FOLDER/.git/hooks")
    do
        # check if file exists
        if [ -f "$file" ]
        then
            rm -fv "$file"
        fi
    done
fi