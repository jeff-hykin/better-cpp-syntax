# find the path to the c lib
output="$(
    nix-instantiate --eval -E '"${
        (rec {
            packageJson = builtins.fromJSON (builtins.readFile ./settings/requirements/simple_nix.json);
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