# keychain is mac-os specific, just FYI
path_to_keychain="$HOME/Library/Keychains/"
if [[ -d "$path_to_keychain" ]]; then
    mkdir -p "./Library/"
    # link all the keys
    ln -sf "$path_to_keychain" "./Library/"
fi

# Make sure the user doesn't accidentally commit their keys/passwords!!
add_to_gitignore "Library/Keychains"