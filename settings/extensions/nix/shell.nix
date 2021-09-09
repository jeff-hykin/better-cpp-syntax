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
    # load most things from the nix.toml
    # 
    main = (builtins.import
        (builtins.getEnv
            ("__FORNIX_NIX_MAIN_CODE_PATH")
        )
    );
    
    # just a helper
    emptyOptions = ({
        buildInputs = [];
        nativeBuildInputs = [];
        shellCode = "";
    });
    
    # 
    # Linux Only
    #
    linuxOnly = if main.stdenv.isLinux then ({
        buildInputs = [];
        nativeBuildInputs = [];
        shellCode = ''
            if [[ "$OSTYPE" == "linux-gnu" ]] 
            then
                true # add important (LD_LIBRARY_PATH, PATH, etc) nix-Linux code here
                export EXTRA_CCFLAGS="$EXTRA_CCFLAGS:-I/usr/include"
            fi
        '';
    }) else emptyOptions;
    
    # 
    # Mac Only
    # 
    macOnly = if main.stdenv.isDarwin then ({
        buildInputs = [];
        nativeBuildInputs = [];
        shellCode = ''
            if [[ "$OSTYPE" = "darwin"* ]] 
            then
                true # add important nix-MacOS code here
                export EXTRA_CCFLAGS="$EXTRA_CCFLAGS:-I/usr/include:${main.packages.darwin.apple_sdk.frameworks.CoreServices}/Library/Frameworks/CoreServices.framework/Headers/"
            fi
        '';
    }) else emptyOptions;
    
    # 
    # Ruby specific
    # 
    rubyGems = (main.packages.bundlerEnv {
        name = "gems";
        ruby = main.packages.ruby;
        gemdir = ../../..;
    });
    
# using the above definitions
in
    # 
    # create a shell
    # 
    main.packages.mkShell {
        # inside that shell, make sure to use these packages
        buildInputs =  main.project.buildInputs ++ macOnly.buildInputs ++ linuxOnly.buildInputs ++ [rubyGems];
        
        nativeBuildInputs =  main.project.nativeBuildInputs ++ macOnly.nativeBuildInputs ++ linuxOnly.nativeBuildInputs;
        
        # run some bash code before starting up the shell
        shellHook = ''
            ${main.project.protectHomeShellCode}
            if [ "$FORNIX_DEBUG" = "true" ]; then
                echo "starting: 'shellHook' inside the 'settings/extensions/nix/shell.nix' file"
            fi
            ${linuxOnly.shellCode}
            ${macOnly.shellCode}
            
            # provide access to ncurses for nice terminal interactions
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${main.packages.ncurses}/lib"
            export LD_LIBRARY_PATH="${main.makeLibraryPath [ main.packages.glib ] }:$LD_LIBRARY_PATH"
            
            if [ "$FORNIX_DEBUG" = "true" ]; then
                echo "finished: 'shellHook' inside the 'settings/extensions/nix/shell.nix' file"
                echo ""
                echo "Tools/Commands mentioned in 'settings/extensions/nix/nix.toml' are now available/installed"
            fi
        '';
    }
