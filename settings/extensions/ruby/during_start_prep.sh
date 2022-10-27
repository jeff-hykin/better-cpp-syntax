export GEM_HOME="$FORNIX_HOME/gems.do_not_sync/"
mkdir "$GEM_HOME" &>/dev/null
# if nix-shell exists
if [ -n "$(command -v "nix-shell")" ]
then
    # create the bundix file
    HOME="$FORNIX_HOME" nix-shell --run "bundix -l" -p bundix -I "nixpkgs=https://github.com/NixOS/nixpkgs/archive/ce6aa13369b667ac2542593170993504932eb836.tar.gz"
fi