# 
# if you want to customize things,
# change settings/automatic_setup/00100#setup_zsh.sh instead of editing this file
# 

# don't let zsh update itself without telling all the other packages 
# instead use nix to update zsh
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

# 
# this shouldnt ever happen (PROJECTR undefined), but just encase
# 
if [[ -z "$PROJECTR_FOLDER" ]]
then
    path_to_file=""
    file_name="settings/projectr_core"
    folder_to_look_in="$PWD"
    while :
    do
        # check if file exists
        if [ -f "$folder_to_look_in/$file_name" ]
        then
            path_to_file="$folder_to_look_in/$file_name"
            break
        else
            if [ "$folder_to_look_in" = "/" ]
            then
                break
            else
                folder_to_look_in="$(dirname "$folder_to_look_in")"
            fi
        fi
    done
    if [ -z "$path_to_file" ]
    then
        #
        # what to do if file never found
        #
        echo "Im a script running with a pwd of:$PWD"
        echo "Im looking for settings/projectr_core in a parent folder"
        echo "Im exiting now because I wasnt able to find it"
        echo "thats all the information I have"
        exit
    fi
    source "$path_to_file"
fi

# run the automatic non-zsh-specific setup
source "$PROJECTR_COMMANDS_FOLDER/tools/automatic_setup"