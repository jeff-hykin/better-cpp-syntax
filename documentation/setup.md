# Auto Setup

TLDR:
- install nix
- run `commands/start` (which uses nix to install everything)
- \* some extra work if you have Windows


### For Windows

* Get [WSL](https://youtu.be/av0UQy6g2FA?t=91) (Windows Subsystem for Linux) or [WSL2](https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10)<br>
    * If you're not familiar with WSL, I'd recommend [watching a quick thing on it like this one](https://youtu.be/av0UQy6g2FA?t=91)
    * Ubuntu 18.04 for WSL is preferred (same as in that linked video), but Ubuntu 20.04 or similar should work.
    * [WSL2](https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10) (just released August 2020) is needed if you want to use your GPU.<br>
* Once WSL is installed (and you have a terminal logged into WSL) follow the Mac/Linux instructions below.
* (tip: when accessing WSL, you probably want to use the VS Code terminal, or the [open source windows terminal](https://github.com/microsoft/terminal) instead of CMD)


<!-- 
Altertive instructions if GUI is needed (matplotlib, tkinter, qt, etc)

### For Windows

* Normally you just install [WSL](https://youtu.be/av0UQy6g2FA?t=91) and everything works, however the project uses a GUI and WSL doesn't like GUI's. <br>So there are a few options:
    1. You might just want to try manually installing everything (manual install details at the bottom)
    2. (Recommended) Install [virtualbox](https://www.virtualbox.org/wiki/Downloads) and setup Ubuntu 18.04 or Ubuntu 20.04
        - Here's [a 10 min tutorial](https://youtu.be/QbmRXJJKsvs?t=62) showing all the steps
        - Once its installed, boot up the Ubuntu machine, open the terminal/console app and follow the Linux instructions below
    3. Get WSL2 with Ubuntu, and use Xming
        - [Video for installing WSL2](https://www.youtube.com/watch?v=8PSXKU6fHp8)
        - If you're not familiar with WSL, I'd recommend [watching a quick thing on it like this one](https://youtu.be/av0UQy6g2FA?t=91)
        - [Guide for Using Xming with WSL2](https://memotut.com/en/ab0ecee4400f70f3bd09/)
        - (when accessing WSL, you probably want to use the VS Code terminal, or the [open source windows terminal](https://github.com/microsoft/terminal) instead of CMD)
        - [Xming link](https://sourceforge.net/projects/xming/?source=typ_redirect)
        - Once you have a WSL/Ubuntu terminal setup, follow the Linux instructions below
 
-->        

### For Mac/Linux

* Just run `eval "$(curl -fsSL git.io/JE2Zm || wget -qO- git.io/JE2Zm)"` in your console/terminal app
    - If you're running a *really* barebones Linux that somehow doesn't have either `curl` or `wget`, install curl or wget and rerun the command
    - This will install nixpkg and interactively help clone/setup this repo
    - If you don't want to run a random internet script (and you *should* always be skeptical of excuting random code!) then
        - Follow the install instructions for [nix](https://nixos.org/guides/install-nix.html)
        - Install `git` if you don't already have it
        - Use git to clone this repository
        - `cd wherever-you-just-cloned-the-repository`
        - `commands/start`
        - (That comand should explain everything else about the project)

* After the intial setup, run the following to get back into the project environment
    - `cd wherever-you-just-cloned-the-repository`
    - `commands/start`