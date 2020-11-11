function add_to_gitignore {
    touch .gitignore
    grep "$1" .gitignore &>/dev/null || echo "

# this next line was auto-added, comment it out if dont want it to be ignored 
$1" >> .gitignore
}

add_to_gitignore ".venv"
# python creates a cache here on MacOS
add_to_gitignore "Library/Caches"