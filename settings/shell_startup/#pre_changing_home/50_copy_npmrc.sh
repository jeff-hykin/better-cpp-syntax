# copy in .npmrc before changing home var 
cp "$HOME/.npmrc" "$PROJECT_HOME/.npmrc" 2>/dev/null

# make sure the user has this in their .npmrc
# (it could contain passwords/keys)
add_to_gitignore "$PROJECT_HOME/.npmrc"