if ! [ "$HOME" = "$FORNIX_HOME" ]
then
    # 
    # MacOS
    # 
    if [ "$(uname)" = "Darwin" ] 
    then
        __temp_var__main="$HOME/.nix-defexpr/channels"
        __temp_var__project="$FORNIX_HOME/.nix-defexpr/channels"
    # 
    # Linux
    # 
    else
        __temp_var__main="$HOME/.nix-defexpr/channels"
        __temp_var__project="$FORNIX_HOME/.nix-defexpr/channels"
    fi
    
    # remove whatever project one might be in the way
    rm -f "$__temp_var__project" 2>/dev/null
    # ensure parent folders exist (*could fail if part of the path is a file)
    mkdir -p "$(dirname "$__temp_var__project")"
    # create link
    ln -sf "$__temp_var__main" "$__temp_var__project"
    
    # clean up
    unset __temp_var__project
    unset __temp_var__main
fi