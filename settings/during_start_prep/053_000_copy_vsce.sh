# copy in .vsce before changing home var 
cp "$HOME/.vsce" "$PROJECTR_HOME/.vsce" 2>/dev/null

# make sure the user has this in their .vsce
# (it could contain passwords/keys)
"$PROJECTR_FOLDER/settings/extensions/git/commands/ignore" "$PROJECTR_HOME/.vsce"
