#!/usr/bin/env bash

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
