export GEM_HOME="$HOME/gems.dont-sync/"
mkdir "$GEM_HOME" &>/dev/null
"$PROJECTR_COMMANDS_FOLDER/tools/ruby/check_gem_modules"