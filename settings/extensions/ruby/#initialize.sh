#!/usr/bin/env bash

# 
# connect when_cleaning
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/when_cleaning/801_ruby.sh" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/when_cleaning/801_ruby.sh" 2>/dev/null
# syslink when_cleaning
ln -s "../extensions/ruby/when_cleaning.sh" "$PROJECTR_FOLDER/settings/when_cleaning/801_ruby.sh"


# 
# connect when_purging
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/when_purging/802_gem_home_cache.sh" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/when_purging/802_gem_home_cache.sh" 2>/dev/null
# syslink when_purging
ln -s "../extensions/ruby/when_purging.sh" "$PROJECTR_FOLDER/settings/when_purging/802_gem_home_cache.sh"


# 
# connect commands
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/commands/tools/ruby" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/commands/tools/ruby" 2>/dev/null
# syslink local tools
ln -s "../../settings/extensions/ruby/commands" "$PROJECTR_FOLDER/commands/tools/ruby"


# 
# connect automatic setup
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/automatic_setup/01300_ruby" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/automatic_setup/01300_ruby" 2>/dev/null
# syslink local tools
ln -s "../extensions/ruby/automatic_setup" "$PROJECTR_FOLDER/settings/automatic_setup/01300_ruby"

# 
# connect automatic setup prep
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/automatic_setup_prep/01300_ruby" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/automatic_setup_prep/01300_ruby" 2>/dev/null
# syslink local tools
ln -s "../extensions/ruby/automatic_setup_prep" "$PROJECTR_FOLDER/settings/automatic_setup_prep/01300_ruby"