# don't let zsh update itself without telling all the other packages 
# instead use nix to update zsh
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

# load custom user settings
# if user just wants to add something (like an export) and not replace everything
# they should use settings/setup_automatically/.dont-sync.exports.sh 
CUSTOM_USER_SETTINGS="./.dont-sync.zshrc"
if [[ -f "$CUSTOM_USER_SETTINGS" ]]; then
    source "$CUSTOM_USER_SETTINGS"
#
# if no custom user settings, then use epic defaults 👌
# 
else
    # this shouldnt ever happen, but just encase
    if [[ -z "$PROJECTR_FOLDER" ]]
    then
        source ./settings/projectr_core
    fi
    export __NO_ZSH_CUSTOM_SETTINGS="true"
fi

# run the automatic non-zsh-specific setup
source "$PROJECTR_FOLDER/settings/setup_automatically/main.sh"