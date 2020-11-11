# NOTE: this depends on setup_tools (add_to_gitignore function) being in the shell_startup

add_to_gitignore ".venv"
# python creates a cache here on MacOS
add_to_gitignore "Library/Caches"