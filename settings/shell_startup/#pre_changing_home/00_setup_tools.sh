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
    system_path="$(which "$1" 2>/dev/null)"
    # make sure its a file
    if [[ -f "$system_path" ]]; then
        mkdir -p ./settings/path_injection.nosync
        # put it in the injections
        ln -sf "$system_path" "./settings/path_injection.nosync"
    else 
        echo "no system '$1' avalible for path injection (some stuff might break)"
    fi
}