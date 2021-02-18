# copy in gitconfig before changing home var 
cp "$HOME/.gitconfig" "$PROJECT_HOME/.gitconfig" 2>/dev/null

# make sure the user has this in their gitignore 
# (the config could contain passwords/keys)
add_to_gitignore "$PROJECT_HOME/.gitconfig"