# this is a helper
relatively_link="$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/relative_link"

# 
# connect during_purge
# 
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/during_purge.sh" "$FORNIX_FOLDER/settings/during_purge/580_mac_library_caches.sh"

# 
# connect during_start_prep
# 
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/during_start_prep.sh" "$FORNIX_FOLDER/settings/during_start_prep/049_000_link_keychain.sh"


unset relatively_link