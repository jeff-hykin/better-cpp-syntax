{ main }:
    let
        saltPackage = (builtins.import
            (../packages/salt.nix)
            main
        );
    in
        {
            buildInputs = [ saltPackage ];
        }