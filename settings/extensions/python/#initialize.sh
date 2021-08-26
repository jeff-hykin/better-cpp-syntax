#!/usr/bin/env bash

# 
# connect automatic_setup
# 
add_to_auto_setup () {
    command_name="$1"
    automatic_setup_name="$2"
    # unlink existing
    rm -f "$PROJECTR_FOLDER/settings/automatic_setup/$automatic_setup_name" 2>/dev/null
    rm -rf "$PROJECTR_FOLDER/settings/automatic_setup/$automatic_setup_name" 2>/dev/null
    # link the command into automatic_setup
    ln -s "../extensions/python/commands/$command_name" "$PROJECTR_FOLDER/settings/automatic_setup/$automatic_setup_name"
}
add_to_auto_setup "setup_venv" "01900_setup_python_venv.sh"
add_to_auto_setup "add_project_to_pythonpath" "02200_setup_pythonpath.sh"
add_to_auto_setup "check_pip_modules" "02100_check_pip_modules.sh"
add_to_auto_setup "refresh_ignores" "02400_python_ignores.sh"


# 
# connect manual_setup
# 
add_to_manual_setup () {
    command_name="$1"
    automatic_setup_name="$2"
    # unlink existing
    rm -f "$PROJECTR_FOLDER/settings/manual_setup/$automatic_setup_name" 2>/dev/null
    rm -rf "$PROJECTR_FOLDER/settings/manual_setup/$automatic_setup_name" 2>/dev/null
    # link the command into automatic_setup
    ln -s "../extensions/python/commands/$command_name" "$PROJECTR_FOLDER/settings/manual_setup/$automatic_setup_name"
}
add_to_manual_setup "add_project_to_pythonpath" "02200_setup_pythonpath.sh"
add_to_manual_setup "refresh_ignores" "02400_python_ignores.sh"

# 
# connect when_cleaning
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/when_cleaning/801_python.sh" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/when_cleaning/801_python.sh" 2>/dev/null
# syslink when_cleaning
ln -s "../extensions/python/when_cleaning.sh" "$PROJECTR_FOLDER/settings/when_cleaning/801_python.sh"


# 
# connect when_purging
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/when_purging/802_remove_venv.sh" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/when_purging/802_remove_venv.sh" 2>/dev/null
# syslink when_purging
ln -s "../extensions/python/when_purging.sh" "$PROJECTR_FOLDER/settings/when_purging/802_remove_venv.sh"


# 
# connect commands
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/commands/tools/python" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/commands/tools/python" 2>/dev/null
# syslink local tools
ln -s "../../settings/extensions/python/commands" "$PROJECTR_FOLDER/commands/tools/python"
