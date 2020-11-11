escape_grep_regex() {
    sed 's/[][\.|$(){}?+*^]/\\&/g' <<< "$*"
}

function add_to_gitignore {
    touch .gitignore
    escaped_name="$(escape_grep_regex $1)"
    grep "$escaped_name$" .gitignore &>/dev/null || echo "

# this next line was auto-added, and may be very important (passwords/auth etc)
# comment it out if dont want it to be ignored (and you know what you're doing)
$1" >> .gitignore
}