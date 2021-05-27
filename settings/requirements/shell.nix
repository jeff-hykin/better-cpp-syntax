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
    # 
    # 
    # nix.json
    # 
    # 
        # load packages and config
        definitions = rec {
            # 
            # load the nix.json cause were going to extract basically everything from there
            # 
            packageJson = builtins.fromJSON (builtins.readFile ./nix.json);
            # 
            # load the store with all the packages, and load it with the config
            # 
            mainRepo = builtins.fetchTarball {url="https://github.com/NixOS/nixpkgs/archive/${packageJson.nix.mainRepo}.tar.gz";};
            mainPackages = builtins.import mainRepo {
                config = packageJson.nix.config;
            };
            # 
            # reorganize the list of packages from:
            #    [ { load: "blah", from:"blah-hash" }, ... ]
            # into a list like:
            #    [ { name: "blah", commitHash:"blah-hash", source: (*an object*) }, ... ]
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
    
    # 
    # 
    # nested packages
    # 
    # 
        # TODO: add support for the nix.json to have nested packages so this section is no longer needed
        nestedPackages = [
            # 
            # this is just a list of all of the standard unix tools
            # 
            definitions.mainPackages.unixtools.arp         # depends on openssl_1_0_2     
            definitions.mainPackages.unixtools.ifconfig    # depends on openssl_1_0_2         
            definitions.mainPackages.unixtools.netstat     # depends on openssl_1_0_2         
            definitions.mainPackages.unixtools.ping        # depends on openssl_1_0_2     
            definitions.mainPackages.unixtools.route       # depends on openssl_1_0_2         
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
    
    # 
    # 
    # Conditional Dependencies
    # 
    # 
        # TODO: add support for the nix.json to have OS specific sections so this is no longer needed
        
        # 
        # Linux Only
        # 
        linuxOnlyPackages = [] ++ definitions.mainPackages.lib.optionals (definitions.mainPackages.stdenv.isLinux) [
        ];
        linuxOnlyNativePackages = [] ++ definitions.mainPackages.lib.optionals (definitions.mainPackages.stdenv.isLinux) [
            definitions.mainPackages.pkgconfig
            definitions.mainPackages.libconfig
            definitions.mainPackages.cmake
        ];
        linuxOnlyShellCode = if !definitions.mainPackages.stdenv.isLinux then "" else ''
            if [[ "$OSTYPE" == "linux-gnu" ]] 
            then
                # example:
                # export CUDA_PATH="${definitions.mainPackages.cudatoolkit}"
                true
            fi
        '';
        
        # 
        # Mac Only
        # 
        macOnlyPackages = [] ++ definitions.mainPackages.lib.optionals (definitions.mainPackages.stdenv.isDarwin) [
        ];
        macOnlyNativePackages = [] ++ definitions.mainPackages.lib.optionals (definitions.mainPackages.stdenv.isDarwin) [
        ];
        macOnlyShellCode = if !definitions.mainPackages.stdenv.isDarwin then "" else ''
        '';
        
    # 
    # 
    # Complex Depedencies
    # 
    # 
        majorCustomDependencies = rec {
            python = [
                definitions.mainPackages.python37
                definitions.mainPackages.python37Packages.setuptools
                definitions.mainPackages.python37Packages.pip
                definitions.mainPackages.python37Packages.virtualenv
                definitions.mainPackages.python37Packages.wheel
            ];
        };
        
        subDepedencies = [] ++ majorCustomDependencies.python ++ nestedPackages;
    
# using those definitions
in
    # create a shell
    definitions.mainPackages.mkShell {
        # inside that shell, make sure to use these packages
        buildInputs = subDepedencies ++ macOnlyPackages ++ linuxOnlyPackages ++ builtins.map (each: each.source) definitions.packagesWithSources;
        
        nativeBuildInputs = [] ++ linuxOnlyNativePackages ++ macOnlyNativePackages;
        
        # run some bash code before starting up the shell
        shellHook = ''
        
        ${linuxOnlyShellCode}
        ${macOnlyShellCode}
        
        source "$PWD/settings/project.config.sh"
        
        # we don't want to give nix or other apps our home folder
        if [[ "$HOME" != "$PROJECTR_HOME" ]] 
        then
            mkdir -p "$PROJECTR_HOME/.cache/"
            ln -s "$HOME/.cache/nix" "$PROJECTR_HOME/.cache/" &>/dev/null
            
            # so make the home folder the same as the project folder
            export HOME="$PROJECTR_HOME"
            # make it explicit which nixpkgs we're using
            export NIX_PATH="nixpkgs=${definitions.mainRepo}:."
        fi
        '';
    }
