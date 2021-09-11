export GEM_HOME="$FORNIX_HOME/gems.do_not_sync/"
mkdir "$GEM_HOME" &>/dev/null
# if nix-shell exists
if [ -n "$(command -v "nix-shell")" ]
then
    # create the bundix file
    HOME="$FORNIX_HOME" nix-shell --run "bundix -l" -p bundix -I "nixpkgs=https://github.com/NixOS/nixpkgs/archive/046f8835dcb9082beb75bb471c28c832e1b067b6.tar.gz"
fi