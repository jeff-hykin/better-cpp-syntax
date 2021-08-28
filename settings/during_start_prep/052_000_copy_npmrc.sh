# copy in .npmrc before changing home var 
cp "$HOME/.npmrc" "$PROJECTR_HOME/.npmrc" 2>/dev/null

# make sure the user has this in their .npmrc
# (it could contain passwords/keys)
"$PROJECTR_FOLDER/settings/extensions/git/commands/ignore" "$PROJECTR_HOME/.npmrc"
