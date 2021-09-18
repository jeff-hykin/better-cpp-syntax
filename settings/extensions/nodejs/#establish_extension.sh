#!/usr/bin/env bash

# 
# this is just a helper (common to most all extensions)
# 
relatively_link="$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/relative_link"

# 
# connect during_clean
# 
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/during_clean.sh" "$FORNIX_FOLDER/settings/during_clean/804_nodejs.sh"

# 
# connect during_purge
# 
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/during_purge.sh" "$FORNIX_FOLDER/settings/during_purge/805_remove_node_modules.sh"

# 
# connect commands
# 
"$relatively_link" "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands" "$FORNIX_COMMANDS_FOLDER/tools/nodejs"

unset relatively_link