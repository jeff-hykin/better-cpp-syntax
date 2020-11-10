# 
# how to add packages?
# 
    # you can search for them here: https://search.nixos.org/packages
    # to find them in the commandline use:
    #     nix-env -qP --available PACKAGE_NAME_HERE | cat
    # ex:
    #     nix-env -qP --available opencv
    #
    # NOTE: some things (like setuptools) just don't show up in the 
    # search results for some reason, and you just have to guess and check 🙃 

# Lets setup some definitions
let        
    definitions = rec {
        # 
        # load the package.json cause were going to extract basically everything from there
        # 
        packageJson = builtins.fromJSON (builtins.readFile ./package.json);
        # 
        # load the store with all the packages, and load it with the config
        # 
        mainRepo = builtins.fetchTarball {url="https://github.com/NixOS/nixpkgs/archive/${packageJson.nix.mainRepo}.tar.gz";};
        mainPackages = builtins.import mainRepo {
            config = packageJson.nix.config;
        };
        # 
        # reorganize the list of packages into a list like:
        #    [ { name: "blah", commitHash:"blah", source: (*an object*) }, ... ]
        # 
        packagesWithSources = builtins.map (
            each: ({
                name = each.load;
                commitHash = each.from;
                source = builtins.getAttr each.load (
                    builtins.import (
                        builtins.fetchTarball {url="https://github.com/NixOS/nixpkgs/archive/${each.from}.tar.gz";}
                    ) {
                        config = packageJson.nix.config;
                    }
                );
            })
        ) packageJson.nix.packages;
    };
    
    # TODO: add support for package.json to have nested packages
    nestedPackages = [
        # definitions.mainPackages.unixtools.arp      # commented out because of security flaws in openssl-1.0.2u, TODO: make a fixed version with overrides
        # definitions.mainPackages.unixtools.ifconfig # commented out because of security flaws in openssl-1.0.2u, TODO: make a fixed version with overrides
        # definitions.mainPackages.unixtools.netstat  # commented out because of security flaws in openssl-1.0.2u, TODO: make a fixed version with overrides
        # definitions.mainPackages.unixtools.ping     # commented out because of security flaws in openssl-1.0.2u, TODO: make a fixed version with overrides
        # definitions.mainPackages.unixtools.route    # commented out because of security flaws in openssl-1.0.2u, TODO: make a fixed version with overrides
        # definitions.mainPackages.unixtools.logger # fail on macos
        # definitions.mainPackages.unixtools.wall   # fail on macos
        definitions.mainPackages.unixtools.col
        definitions.mainPackages.unixtools.column
        definitions.mainPackages.unixtools.fdisk
        definitions.mainPackages.unixtools.fsck
        definitions.mainPackages.unixtools.getconf
        definitions.mainPackages.unixtools.getent
        definitions.mainPackages.unixtools.getopt
        definitions.mainPackages.unixtools.hexdump
        definitions.mainPackages.unixtools.hostname
        definitions.mainPackages.unixtools.killall
        definitions.mainPackages.unixtools.locale
        definitions.mainPackages.unixtools.more
        definitions.mainPackages.unixtools.mount
        definitions.mainPackages.unixtools.ps
        definitions.mainPackages.unixtools.quota
        definitions.mainPackages.unixtools.script
        definitions.mainPackages.unixtools.sysctl
        definitions.mainPackages.unixtools.top
        definitions.mainPackages.unixtools.umount
        definitions.mainPackages.unixtools.whereis
        definitions.mainPackages.unixtools.write
        definitions.mainPackages.unixtools.xxd
    ];
    
    # TODO: add support for OS-specific packages (if statement inside package inclusion)
    packagesForMacOnly = [] ++ definitions.mainPackages.lib.optionals (definitions.mainPackages.stdenv.isDarwin) [
    ];
# using those definitions
in
    # create a shell
    definitions.mainPackages.mkShell {
        # inside that shell, make sure to use these packages
        buildInputs = nestedPackages ++ packagesForMacOnly ++ builtins.map (each: each.source) definitions.packagesWithSources;
        
        # run some bash code before starting up the shell
        shellHook = ''
        # we don't want to give nix or other apps our home folder
        if [[ "$HOME" != "$(pwd)" ]] 
        then
            #
            # find and run all the startup scripts in alphabetical order
            #
            for file in ./settings/shell_startup/#pre_changing_home/*
            do
                # make sure its a file
                if [[ -f $file ]]; then
                    source $file
                fi
            done
            
            mkdir -p .cache/
            ln -s "$HOME/.cache/nix" "./.cache/" &>/dev/null
            
            # so make the home folder the same as the project folder
            export HOME="$(pwd)"
            # make it explicit which nixpkgs we're using
            export NIX_PATH="nixpkgs=${definitions.mainRepo}:."
            
            # start zsh
            nix-shell --pure --command zsh
            exit
        fi
        '';
    }