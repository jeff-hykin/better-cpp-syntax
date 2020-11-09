# copy in .npmrc before changing home var 
cp "$HOME/.npmrc" ./.npmrc

# make sure the user has this in their .npmrc
# (it could contain passwords/keys)
add_to_gitignore .npmrc