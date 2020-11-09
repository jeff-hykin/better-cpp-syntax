function add_to_gitignore {
    touch .gitignore
    grep "$1" .gitignore || echo "

# this next line was auto-added, comment it out if dont want it to be ignored 
$1" >> .gitignore
}