# make sure commands are executable
chmod -R ugo+x "$PROJECTR_COMMANDS_FOLDER" &>/dev/null || sudo chmod -R ugo+x "$PROJECTR_COMMANDS_FOLDER" &>/dev/null

# 
# create aliases for all of the folders to allow recursive execution
# 
# yes its ugly, welcome to bash programming
for each in $(find "$PROJECTR_COMMANDS_FOLDER" -maxdepth 1)
do
    # if its a folder
    if [[ -d "$each" ]]
    then
        name="$(basename "$each")"
        eval '
        function '"$name"' {
            # enable globbing
            setopt extended_glob &>/dev/null
            shopt -s globstar &>/dev/null
            shopt -s dotglob &>/dev/null
            local search_path='"'""$each"'/'"'"'
            local argument_combination="$search_path/$1"
            while [[ -n "$@" ]]
            do
                shift 1
                for each in "$search_path/"**/*
                do
                    if [[ "$argument_combination" = "$each" ]]
                    then
                        # if its a folder, then we need to go deeper
                        if [[ -d "$each" ]]
                        then
                            search_path="$each"
                            argument_combination="$argument_combination/$1"
                            
                            # if there is no next argument
                            if [[ -z "$1" ]]
                            then
                                printf "\nThat is a sub folder, not a command\nValid sub-options are\n" 1>&2
                                ls -1 --color -F "$each" | sed '"'"'s/^/    /'"'"' 1>&2
                                return 1 # error, no command
                            fi
                            
                            break
                        # if its a file, run it with the remaining arguments
                        elif [[ -f "$each" ]]
                        then
                            "$each" "$@"
                            # make exit status identical to executed program
                            return $?
                        fi
                    fi
                done
            done
            printf "\nI could not find that sub command\n" 1>&2
            printf "Valid options are:\n" 1>&2
            ls -1 --color -F "$search_path" | sed '"'"'s/^/    /'"'"' 1>&2
            return 1 # error, no command
        }
        '
    fi
done
