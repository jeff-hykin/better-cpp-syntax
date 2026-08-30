{
    description = "Better C++ Syntax";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        nixpkgsWithNodejs18.url = "https://github.com/NixOS/nixpkgs/archive/a71323f68d4377d12c04a5410e214495ec598d4c.tar.gz";
        nixpkgsWithRuby.url = "https://github.com/NixOS/nixpkgs/archive/ebf88190cce9a092f9c7abe195548057a0273e51.tar.gz";
        home-manager.url = "github:nix-community/home-manager/release-25.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        xome.url = "github:jeff-hykin/xome";
        xome.inputs.nixpkgs.follows = "nixpkgs";
        xome.inputs.home-manager.follows = "home-manager";
    };
    outputs = { self, nixpkgs, nixpkgsWithNodejs18, nixpkgsWithRuby, xome, ... }:
        xome.superSimpleMakeHome { inherit nixpkgs; pure = true; } ({system, ...}:
            let
                setup = {
                    system = system;

                    # This is where you allow insecure/unfree packages
                    config = {
                        allowUnfree = true;
                        allowInsecure = true;
                        permittedInsecurePackages = [
                            "python-2.7.18.8"
                            "python-2.7.18.6"
                            "openssl-1.0.2u"
                        ];
                    };
                };
                pkgs = import nixpkgs setup;
                pkgsWithNodejs18 = import nixpkgsWithNodejs18 setup;
                pkgsWithRuby = import nixpkgsWithRuby setup;
            in
                {
                    # for home-manager examples, see: https://deepwiki.com/nix-community/home-manager/5-configuration-examples
                    # all home-manager options: https://nix-community.github.io/home-manager/options.xhtml
                    home.homeDirectory = "/tmp/virtual_homes/better_cpp_syntax";
                    home.stateVersion = "25.05";
                    home.packages = [
                        # vital stuff
                        pkgs.coreutils-full

                        # optional stuff
                        pkgs.bash
                        pkgs.gnugrep
                        pkgs.findutils
                        pkgs.wget
                        pkgs.curl
                        pkgs.unixtools.locale
                        pkgs.unixtools.more
                        pkgs.unixtools.ps
                        pkgs.unixtools.getopt
                        pkgs.unixtools.ifconfig
                        pkgs.unixtools.hostname
                        pkgs.unixtools.ping
                        pkgs.unixtools.hexdump
                        pkgs.unixtools.killall
                        pkgs.unixtools.mount
                        pkgs.unixtools.sysctl
                        pkgs.unixtools.top
                        pkgs.unixtools.umount
                        pkgs.git

                        # project specific
                        pkgs.jq
                        pkgsWithNodejs18.nodejs
                        pkgs.python3
                        pkgs.cmake
                        pkgs.pkg-config
                        pkgs.libffi
                        pkgsWithRuby.ruby.devEnv # ruby 2.7.8
                        pkgsWithRuby.bundix
                        pkgsWithRuby.sqlite
                        pkgsWithRuby.libpcap
                        pkgsWithRuby.postgresql
                        pkgs.libxml2
                        pkgs.libxslt
                        pkgs.gnumake
                        pkgs.ncurses5
                        pkgs.openssh
                    ];

                    programs = {
                        home-manager = {
                            enable = true;
                        };
                        zsh = {
                            enable = true;
                            enableCompletion = true;
                            autosuggestion.enable = true;
                            syntaxHighlighting.enable = true;
                            shellAliases.ll = "ls -la";
                            history.size = 100000;
                            # this is kinda like .zshrc
                            initContent = ''
                                # this enables some impure stuff like sudo, comment it out to get FULL purity
                                export PATH="$PATH:/usr/bin/"

                                #
                                # Ruby setup
                                #
                                export GEM_HOME="$HOME/gems.ignore/"
                                # if not setup yet, then setup ruby
                                if ! [ -d "$GEM_HOME" ]
                                then
                                    mkdir "$GEM_HOME" &>/dev/null
                                    bundix -l
                                    bundler install
                                fi

                                #
                                # Npm setup
                                #
                                if ! [ -d "./node_modules" ]; then
                                    npm install
                                fi
                            '';
                        };
                        starship = {
                            enable = true;
                            enableZshIntegration = true;
                        };
                    };
                }
        );
}
