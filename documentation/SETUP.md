# Setup

TLDR: install `nix`, run `commands/start`, and everything will be auto installed
<br>

### For Windows

* Get [WSL](https://youtu.be/av0UQy6g2FA?t=91) (Windows Subsystem for Linux) or [WSL2](https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10)<br>
    * If you're not familiar with WSL, I'd recommend [watching a quick thing on it like this one](https://youtu.be/av0UQy6g2FA?t=91)
    * Ubuntu 18.04 for WSL is preferred (same as in that linked video), but Ubuntu 20.04 or similar should work.
    * [WSL2](https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10) (just released August 2020) is needed if you want to use your GPU.<br>
* Once WSL is installed (and you have a terminal logged into WSL) follow the Mac/Linux instructions below.
* (protip: use the VS Code terminal instead of CMD when accessing WSL)

### For Mac/Linux

* Install [nix](https://nixos.org/guides/install-nix.html), more detailed guide [here](https://nixos.org/manual/nix/stable/#chap-installation)
    * Just run the following in your console/terminal app
        * `sudo apt-get update 2>/dev/null`
        * If you're on MacOS Big Sur
            *  see [this](https://duan.ca/2020/12/13/nix-on-macos-11-big-sur/) tutorial
        * If you're on MacOS Catalina, run:
            * `sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume `
        * If you're not, run:
            * `curl -L https://nixos.org/nix/install | bash`
        * `source $HOME/.nix-profile/etc/profile.d/nix.sh`
        * (may need to restart console/terminal)
* Install `git`
    * (if you don't have git just run `nix-env -i git`)
* Clone/Open the project
    * `cd wherever-you-want-to-save-this-project`<br>
    * `git clone https://github.com/*this-repo-url*`
    * `cd *this-repo*`
* Actually run some code
    * run `commands/start` to get into the project environment
        * Note: this will almost certainly take a while the first time because it will auto-install exact versions of everything: `node`, `python`, `ruby`, all modules for them, etc
    * run `project commands` to list the project commands
