# connect the tealdeer cache to prevent wasted duplicates

# 
# MacOS
# 
if [ "$(uname)" = "Darwin" ] 
then
    # make the real home folder if it doesn't exist
    if ! [ -d "$HOME/Library/Caches/tealdeer" ]
    then
        mkdir -p "$HOME/Library/Caches/tealdeer"
    fi
    
    # link the real home folder to the project 
    if [ -d "$HOME/Library/Caches/tealdeer" ]
    then
        if ! [ -d "$FORNIX_HOME/Library/Caches/tealdeer" ]
        then
            ln -s "$HOME/Library/Caches/tealdeer" "$FORNIX_HOME/Library/Caches/tealdeer"
        fi
    fi
# 
# Linux
# 
else
    # make the real home folder if it doesn't exist
    if ! [ -d "$HOME/.cache/tldr" ]
    then
        mkdir -p "$HOME/.cache/tldr"
    fi
    
    # link the real home folder to the project 
    if [ -d "$HOME/.cache/tldr" ]
    then
        if ! [ -d "$FORNIX_HOME/.cache/tldr" ]
        then
            ln -s "$HOME/.cache/tldr" "$FORNIX_HOME/.cache/tldr"
        fi
    fi
fi