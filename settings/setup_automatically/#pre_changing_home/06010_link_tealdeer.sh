# connect the tealdeer cache to prevent wasted duplicates
if [[ -d "$HOME/.cache/tealdeer" ]]
then
    if ! [[ -d "$PROJECTR_HOME/.cache/tealdeer" ]]
    then
        ln -s "$HOME/.cache/tealdeer" "$PROJECTR_HOME/.cache/tealdeer"
    fi
fi