# enable globbing for zsh
setopt extended_glob &>/dev/null
# enable globbing for bash
shopt -s globstar &>/dev/null
shopt -s dotglob &>/dev/null

# 
# find and run all the startup scripts in alphabetical order
# 
for file in "$PROJECTR_FOLDER/settings/setup_manually/steps/"*
do
    # make sure its a file
    if [[ -f "$file" ]]; then
        source "$file"
    fi
done