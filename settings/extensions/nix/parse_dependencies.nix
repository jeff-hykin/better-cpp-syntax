# 
# summary 
#     this file exports a function that does a few basic things 
#     1. parses the nix.toml file and return nix package objects
#     2. exports some basic information about the package dependencies to a json file
#     3. returns a "main" object that has all the basic builtin or builtin-like functionality
(rec {
    # 
    # create a standard library for convienience 
    # 
    frozenStd = (builtins.import 
        (builtins.fetchTarball
            ({url="https://github.com/NixOS/nixpkgs/archive/8917ffe7232e1e9db23ec9405248fd1944d0b36f.tar.gz";})
        )
        ({})
    );
    main = (frozenStd.lib.mergeAttrs
        (builtins) # <- for import, fetchTarball, etc 
        (frozenStd.lib.mergeAttrs
            ({ stdenv = frozenStd.stdenv; })
            (frozenStd.lib) # <- for mergeAttrs, optionals, getAttrFromPath, etc 
        )
    );
    # 
    # pull info from the config files
    # 
    nixSettings = (main.fromTOML
        (main.readFile 
            (main.getEnv
                "__PROJECTR_NIX_SETTINGS_PATH"
            )
        )
    );
    # 
    # load the nix.toml cause were going to extract basically everything from there
    # 
    packageToml = (main.fromTOML
        (main.readFile
            (main.getEnv 
                ("__PROJECTR_NIX_PACKAGES_FILE_PATH")
            )
        )
    );
    # 
    # load the store with all the packages, and load it with the config
    # 
    mainRepo = (main.fetchTarball
        ({url="https://github.com/NixOS/nixpkgs/archive/${nixSettings.mainRepo}.tar.gz";})
    );
    mainPackages = (main.import
        (mainRepo)
        ({ config = nixSettings.config;})
    );
    packagesForThisMachine = (main.filter
        (eachPackage:
            (main.all
                # if all are true
                (x: x)
                (main.optionals
                    # if package depends on something
                    (main.hasAttr "onlyIf" eachPackage)
                    # basically convert something like ["stdev", "isLinux"] to main.stdenv.isLinux
                    (main.map
                        (eachCondition:
                            (main.getAttrFromPath
                                (eachCondition)
                                (main)
                            )
                        )
                        (eachPackage.onlyIf)
                    )
                )
            )
        )
        (packageToml.packages)
    );
    # 
    # reorganize the list of packages from:
    #    [ { load: "blah", from:"blah-hash" }, ... ]
    # into a list like:
    #    [ { name: "blah", commitHash:"blah-hash", source: (*an object*) }, ... ]
    #
    tomlPackagesWithSources = (main.map
        (each: 
            ({
                name = (main.concatMapStringsSep
                    (".")
                    (each: each)
                    (each.load)
                );
                commitHash = each.from;
                asNativeBuildInput = (
                    (main.hasAttr
                        ("asNativeBuildInput")
                        (each)
                    )
                    &&
                    each.asNativeBuildInput
                );
                value =
                    # if it says where (e.g. from)
                    if 
                        (main.hasAttr
                            ("from")
                            (each)
                        )
                    # then load it from that place
                    then 
                        (rec {
                            package = (main.getAttrFromPath
                                (each.load)
                                (main.import
                                    # if its a string, assume its a nixpkg commit hash
                                    (
                                        if 
                                            (main.isString
                                                (each.from)
                                            )
                                        then
                                            (main.fetchTarball
                                                ({url="https://github.com/NixOS/nixpkgs/archive/${each.from}.tar.gz";})
                                            )
                                        # otherwise assume its the details for a github repo
                                        else
                                            (main.fetchGit
                                                (each.from.fetchGit)
                                            )
                                    )
                                    (
                                        if 
                                            (
                                                (main.isString
                                                    (each.from)
                                                )
                                                ||
                                                (!main.hasAttr
                                                    ("options")
                                                    (each.from)
                                                )
                                            )
                                        then
                                            ({})
                                        # otherwise assume its the details for a github repo
                                        else
                                            (each.from.options)
                                    )
                                )
                            );
                            return = (
                                if 
                                    (main.hasAttr
                                        ("override")
                                        (each)
                                    )
                                then
                                    (package.override
                                        (each.override)
                                    )
                                else
                                    package
                            );
                        }.return)
                    # otherwise just default to getting it from mainPackages
                    else 
                        (main.getAttrFromPath
                            (each.load)
                            (mainPackages)
                        )
                ;
            })
        )
        (packagesForThisMachine)
    );
    listedDepedencyPackages = (main.listToAttrs 
        (tomlPackagesWithSources)
    );
    packages = (main.mergeAttrs
        mainPackages
        listedDepedencyPackages
    );
    tomlAndBuiltinPackagesWithSources = (tomlPackagesWithSources ++ 
        [  
            {
                name = "glib";
                value = packages.glib;
            }
            {
                name = "cc";
                value = main.stdenv.cc.cc;
            }
        ]
    );
    buildInputs = (main.map
        (each: each.value)
        (main.filter
            (each: !each.asNativeBuildInput)
            (tomlPackagesWithSources)
        )
    );
    nativeBuildInputs = (main.map
        (each: each.value)
        (main.filter
            (each: each.asNativeBuildInput)
            (tomlPackagesWithSources)
        )
    );
    depedencyPackages = (main.listToAttrs 
        (tomlAndBuiltinPackagesWithSources)
    );
    packagePathsAsJson = (main.toJSON
        ({
            packagePathFor = depedencyPackages;
            libPathFor = (main.listToAttrs
                (main.map
                    (each:
                        ({
                            name = each.name;
                            value = "${main.makeLibraryPath [ each.value ]}";
                        })
                    )
                    (tomlAndBuiltinPackagesWithSources)
                )
            );
        })
    );
    return = (main.mergeAttrs
        (main)
        ({
            nixPath = "${mainRepo}";
            packages = packages;
            project = {
                buildInputs = buildInputs;
                nativeBuildInputs = nativeBuildInputs;
                protectHomeShellCode = ''
                    # FIXME: have this search for the projectr_core instead of assuming it is relative to $PWD
                    source "$PWD/settings/projectr_core"
                    
                    # ensure that the folder exists
                    mkdir -p "$(dirname "$__PROJECTR_NIX_PATH_EXPORT_FILE")"
                    echo ${main.escapeShellArg (packagePathsAsJson)} > "$__PROJECTR_NIX_PATH_EXPORT_FILE"
                    
                    if [ -n "$PROJECTR_HOME" ]
                    then
                        # we don't want to give nix or other apps our home folder
                        if [[ "$HOME" != "$PROJECTR_HOME" ]] 
                        then
                            mkdir -p "$PROJECTR_HOME/.cache/"
                            ln -s "$HOME/.cache/nix" "$PROJECTR_HOME/.cache/" &>/dev/null
                            
                            # so make the home folder the same as the project folder
                            export HOME="$PROJECTR_HOME"
                            # make it explicit which nixpkgs we're using
                            export NIX_PATH="nixpkgs=${mainRepo}:."
                        fi
                    fi
                '';
            };
            
        })
    );
}).return