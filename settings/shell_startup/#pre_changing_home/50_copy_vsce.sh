# copy in .vsce before changing home var 
cp "$HOME/.vsce" "$new_home/.vsce" 2>/dev/null

# make sure the user has this in their .vsce
# (it could contain passwords/keys)
add_to_gitignore "$new_home/.vsce"