# keychain is mac-os specific, just FYI
path_to_keychain="$HOME/Library/Keychains/"
if [[ -d "$path_to_keychain" ]]; then
    mkdir -p "$new_home/Library/"
    # link all the keys
    ln -sf "$path_to_keychain" "$new_home/Library/"
fi

# Make sure the user doesn't accidentally commit their keys/passwords!!
add_to_gitignore "$new_home/Library/Keychains"