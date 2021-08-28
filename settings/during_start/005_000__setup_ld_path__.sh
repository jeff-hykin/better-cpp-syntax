# add the path to the c lib, which prevents the libstdc++.so.6 errors 
export LD_LIBRARY_PATH="$("$__PROJECTR_NIX_COMMANDS/lib_path_for" "cc"):$LD_LIBRARY_PATH"