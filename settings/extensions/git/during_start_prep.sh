# copy in gitconfig before changing home var 
# check if file exists
if [ -f ""$HOME/.gitconfig"" ]
then
    cp "$HOME/.gitconfig" "$PROJECTR_HOME/.gitconfig" 2>/dev/null
fi

# make sure the user has this in their gitignore 
# (the config could contain passwords/keys)
"$PROJECTR_FOLDER/settings/extensions/git/commands/ignore" "$PROJECTR_HOME/.gitconfig"