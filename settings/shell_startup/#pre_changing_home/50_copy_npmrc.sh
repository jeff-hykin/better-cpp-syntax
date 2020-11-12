# copy in .npmrc before changing home var 
cp "$HOME/.npmrc" "$new_home/.npmrc" 2>/dev/null

# make sure the user has this in their .npmrc
# (it could contain passwords/keys)
add_to_gitignore "$new_home/.npmrc"