# find the path to the c lib
# FIXME: this needs better escaping of the $PROJECTR_FOLDER
output="$(
    nix-instantiate --eval -E '"${
        (rec {
            packageJson = builtins.fromJSON (builtins.readFile "'"$PROJECTR_FOLDER/settings/requirements/nix.json"'");
            mainRepo = builtins.fetchTarball {url="https://github.com/NixOS/nixpkgs/archive/${packageJson.nix.mainRepo}.tar.gz";};
            mainPackages = builtins.import mainRepo {
                config = packageJson.nix.config;
            };
            path = mainPackages.stdenv.cc.cc.lib;
        }).path
    }"' | sed -E 's/^"|"$//g'
)"
# prevents the libstdc++.so.6 errors 
export LD_LIBRARY_PATH="$output/lib/:$LD_LIBRARY_PATH"