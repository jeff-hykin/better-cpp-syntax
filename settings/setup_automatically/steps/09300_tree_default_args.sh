function tree {
    "$(nix_path_for tree)/bin/tree" -C --dirsfirst  -A -F --noreport "$@"
}