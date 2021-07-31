#!/usr/bin/env bash

# 
# connect when_cleaning
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/when_cleaning/804_nodejs.sh" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/when_cleaning/804_nodejs.sh" 2>/dev/null
# syslink when_cleaning
ln -s "../extensions/nodejs/when_cleaning.sh" "$PROJECTR_FOLDER/settings/when_cleaning/804_nodejs.sh"


# 
# connect when_purging
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/when_purging/805_remove_node_modules.sh" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/when_purging/805_remove_node_modules.sh" 2>/dev/null
# syslink when_purging
ln -s "../extensions/nodejs/when_purging.sh" "$PROJECTR_FOLDER/settings/when_purging/805_remove_node_modules.sh"


# 
# connect commands
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/commands/tools/nodejs" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/commands/tools/nodejs" 2>/dev/null
# syslink local tools
ln -s "../../settings/extensions/nodejs/commands" "$PROJECTR_FOLDER/commands/tools/nodejs"
