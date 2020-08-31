# ensure commands folder exists
if ! [[ -d "./commands" ]]; then
    # remove a potenial file
    rm -f ./commands
    # make the folder
    mkdir ./commands
fi