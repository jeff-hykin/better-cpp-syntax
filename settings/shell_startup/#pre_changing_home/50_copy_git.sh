# copy in gitconfig before changing home var 
cp "$HOME/.gitconfig" ./.gitconfig

# make sure the user has this in their gitignore 
# (the config could contain passwords/keys)
add_to_gitignore .gitconfig