#!/usr/bin/env bash

# 
# this is just a helper (common to most all extensions)
# 
relatively_link="$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/relative_link"

# 
# connect during_start
# 
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/setup_venv"                "$FORNIX_FOLDER/settings/during_start/019_000_setup_python_venv.sh"
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/add_project_to_pythonpath" "$FORNIX_FOLDER/settings/during_start/022_000_setup_pythonpath.sh"
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/ensure_pip_modules"        "$FORNIX_FOLDER/settings/during_start/021_000_ensure_pip_modules.sh"
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/refresh_ignores"           "$FORNIX_FOLDER/settings/during_start/024_000_python_ignores.sh"


# 
# connect during_manual_start
# 
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/add_project_to_pythonpath" "$FORNIX_FOLDER/settings/during_manual_start/022_000_setup_pythonpath.sh"
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/refresh_ignores"           "$FORNIX_FOLDER/settings/during_manual_start/024_000_python_ignores.sh"

# 
# connect during_clean
# 
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/during_clean.sh" "$FORNIX_FOLDER/settings/during_clean/801_python.sh"

# 
# connect during_purge
# 
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/during_purge.sh" "$FORNIX_FOLDER/settings/during_purge/802_remove_venv.sh"

# 
# connect commands
# 
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands" "$FORNIX_COMMANDS_FOLDER/tools/python"

# 
# connect git hooks
# 
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/ensure_pip_modules" "$FORNIX_FOLDER/settings/extensions/git/hooks/post-update/901_check_pip_modules"
relative_link__file_to__ "$__THIS_FORNIX_EXTENSION_FOLDERPATH__/commands/ensure_pip_modules" "$FORNIX_FOLDER/settings/extensions/git/hooks/post-merge/901_check_pip_modules"

unset relatively_link