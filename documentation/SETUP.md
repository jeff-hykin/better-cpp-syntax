# How to setup the managed environment

<br>

**NOTE** : You can also use the manual setup listed at the bottom. <br>
The managed environment is very reliable way to setup.<br>
(and if you already have nix, it's pretty much 100% automated)

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
    * `git clone https://github.com/jeff-hykin/cpp-textmate-grammar`
    * `cd cpp-textmate-grammar`
* Actually run some code
    * run `nix-shell` to get into the project environment
        * Note: this will almost certainly take a while the first time because it will auto-install exact versions of everything: `node`, `python`, `ruby`, all modules for them, etc
    * run `commands` to see all of the project commands


# Manual project setup

- Install python3
- Install the python modules with `python3 -m pip install -r ./settings/requirements/requirements.txt`
- Run the script `./settings/commands/commands` to see avalible commands