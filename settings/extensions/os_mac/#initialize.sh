
# 
# connect when_purging
# 
# unlink existing
rm -f "$PROJECTR_FOLDER/settings/when_purging/580_mac_library_caches.sh" 2>/dev/null
rm -rf "$PROJECTR_FOLDER/settings/when_purging/580_mac_library_caches.sh" 2>/dev/null
# syslink when_purging
ln -s "../extensions/os_mac/when_purging.sh" "$PROJECTR_FOLDER/settings/when_purging/580_mac_library_caches.sh"
