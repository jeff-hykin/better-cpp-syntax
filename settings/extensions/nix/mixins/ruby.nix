{ main }:
    let
        rubyGems = (main.packages.bundlerEnv {
            name = "gems";
            ruby = main.packages.ruby;
            gemdir = ../../..;
        });
    in
        {
            buildInputs = [
                (rubyGems
                    (main.lowPrio rubyGems.wrappedRuby)
                )
            ];
        }