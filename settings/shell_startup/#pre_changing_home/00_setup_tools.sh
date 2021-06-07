escape_grep_regex() {
    sed 's/[][\.|$(){}?+*^]/\\&/g' <<< "$*"
}

function add_to_gitignore {
    touch .gitignore
    escaped_name="$(escape_grep_regex $1)"
    grep -E -- "$escaped_name$" .gitignore &>/dev/null || echo "

# this next line was auto-added, and may be very important (passwords/auth etc)
# comment it out if dont want it to be ignored (and you know what you're doing)
$1" >> .gitignore
}

function inject_into_path {
    PROJECTR_FOLDER="$PWD"
    # if it is an absolute path use it directly
    if [[ -f "$1" ]]
    then
        local system_path="$1"
    # if it is the name of a command, then find the path
    else
        local system_path="$(which "$1" 2>/dev/null)"
    fi
    # make sure its a file
    if [[ -f "$system_path" ]]; then
        mkdir -p "$PROJECTR_FOLDER/settings/path_injection.nosync"
        # put it in the injections, and use the real home variable
        local new_executable="$PROJECTR_FOLDER/settings/path_injection.nosync/$(basename "$system_path")"
        echo "#!/usr/bin/env bash
        HOME='$HOME' '$system_path' "'"$@"' > "$new_executable"
        # make sure we can execute it
        chmod u+wrx "$new_executable"
    else 
        echo "no system '$1' avalible for path injection (some stuff might break)"
    fi
}