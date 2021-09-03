if [ -d "$FORNIX_FOLDER" ]
then
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$HOME/gems.do_not_sync/"
    "$FORNIX_FOLDER/settings/extensions/#standard/commands/tools/file_system/remove" "$HOME/.bundle/"
fi