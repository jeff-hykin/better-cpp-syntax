# connect the deno cache to prevent wasted duplicates

if ! [ "$HOME" = "$FORNIX_HOME" ]
then
    __temp_var__real_home_cache_dir=""
    __temp_var__project_home_cache_dir=""
    
    # 
    # MacOS
    # 
    if [ "$(uname)" = "Darwin" ] 
    then
        __temp_var__real_home_cache_dir="$HOME/Library/Caches"
        __temp_var__project_home_cache_dir="$FORNIX_HOME/Library/Caches"
    # 
    # Linux
    # 
    else
        __temp_var__real_home_cache_dir="$HOME/.cache"
        __temp_var__project_home_cache_dir="$FORNIX_HOME/.cache"
    fi
    
    # folder we want to connect
    __temp_var__what_to_connect="deno/deps"
    __temp_var__main="$__temp_var__real_home_cache_dir/$__temp_var__what_to_connect"
    __temp_var__project="$__temp_var__project_home_cache_dir/$__temp_var__what_to_connect"
    
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
    unset __temp_var__project_home_cache_dir
    unset __temp_var__real_home_cache_dir
    unset __temp_var__what_to_connect
fi