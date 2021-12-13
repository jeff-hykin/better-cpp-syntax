# connect the tealdeer cache to prevent wasted duplicates

if ! [ "$HOME" = "$FORNIX_HOME" ]
then
    # 
    # MacOS
    # 
    if [ "$(uname)" = "Darwin" ] 
    then
        __temp_var__main="$HOME/Library/Caches/tealdeer"
        __temp_var__project="$FORNIX_HOME/Library/Caches/tealdeer"
    # 
    # Linux
    # 
    else
        __temp_var__main="$HOME/.cache/tldr"
        __temp_var__project="$FORNIX_HOME/.cache/tldr"
    fi
    
    # make the real home folder if it doesn't exist
    if ! [ -d "$__temp_var__main" ]
    then
        # remove if corrupted
        rm -f "$__temp_var__main" 2>/dev/null
        # make sure its a folder
        mkdir -p "$__temp_var__main"
    fi
    
    # remove whatever project one might be in the way
    rm -rf "$__temp_var__project" 2>/dev/null
    # ensure parent folders exist (*could fail if part of the path is a file)
    mkdir -p "$(dirname "$__temp_var__project")"
    # create link
    ln -sf "$__temp_var__main" "$__temp_var__project"
    
    # clean up
    unset __temp_var__project
    unset __temp_var__main
fi