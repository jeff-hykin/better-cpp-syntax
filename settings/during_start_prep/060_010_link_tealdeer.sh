# connect the tealdeer cache to prevent wasted duplicates

if ! [ "$HOME" = "$FORNIX_HOME" ]
then
    # 
    # MacOS
    # 
    if [ "$(uname)" = "Darwin" ] 
    then
        # make the real home folder if it doesn't exist
        if ! [ -d "$HOME/Library/Caches/tealdeer" ]
        then
            rm -f "$HOME/Library/Caches/tealdeer" 2>/dev/null
            mkdir -p "$HOME/Library/Caches/tealdeer"
        fi
        
        # link the real home folder to the project 
        if [ -d "$HOME/Library/Caches/tealdeer" ]
        then
            rm -rf "$FORNIX_HOME/Library/Caches/tealdeer" 2>/dev/null
            ln -sf "$HOME/Library/Caches/tealdeer" "$FORNIX_HOME/Library/Caches/tealdeer"
        fi
    # 
    # Linux
    # 
    else
        # make the real home folder if it doesn't exist
        if ! [ -d "$HOME/.cache/tldr" ]
        then
            rm -f "$HOME/.cache/tldr" 2>/dev/null
            mkdir -p "$HOME/.cache/tldr"
        fi
        
        # link the real home folder to the project 
        if [ -d "$HOME/.cache/tldr" ]
        then
            rm -rf "$FORNIX_HOME/.cache/tldr" 2>/dev/null
            ln -sf "$HOME/.cache/tldr" "$FORNIX_HOME/.cache/tldr"
        fi
    fi
fi