# copy in .vsce before changing home var 
cp "$HOME/.vsce" "$PROJECT_HOME/.vsce" 2>/dev/null

# make sure the user has this in their .vsce
# (it could contain passwords/keys)
add_to_gitignore "$PROJECT_HOME/.vsce"