function add_to_gitignore {
    touch .gitignore
    grep "$1" .gitignore &>/dev/null || echo "

# this next line was auto-added, comment it out if dont want it to be ignored 
$1" >> .gitignore
}

function inject_into_path {
    system_path="$(which "$1")"
    # make sure its a file
    if [[ -f "$system_path" ]]; then
        mkdir -p ./settings/path_injection.nosync
        # put it in the injections
        ln -sf "$system_path" "./settings/path_injection.nosync"
    else 
        echo "no system '$1' avalible for path injection (some stuff might break)"
    fi
}