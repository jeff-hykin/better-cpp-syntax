# copy in .vsce before changing home var 
cp "$HOME/.vsce" "$PROJECTR_HOME/.vsce" 2>/dev/null

# make sure the user has this in their .vsce
# (it could contain passwords/keys)
"$PROJECTR_COMMANDS_FOLDER/tools/add_to_gitignore" "$PROJECTR_HOME/.vsce"
