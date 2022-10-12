# Setup The Project Environment

### If you're an Experienced/Senior Dev

- (Don't git clone)
- Run this: `eval "$(curl -fsSL git.io/JE2Zm || wget -qO- git.io/JE2Zm)"`
- If you're on Windows, run it inside WSL (Ubuntu 20.04 preferably)
- If you're a responsible human being and therefore don't want run a sketchy internet script, props to you 👍. Take a look at the "What is that `eval` command doing?" section at the bottom and you'll be able to run the commands yourself.

### If the above instructions didn't make sense

- Mac/Linux users
    - open up your terminal/console app
    - use `cd` to get to the folder where you want this project ([tutorial on how to use cd here](https://github.com/jeff-hykin/fornix/blob/b6fd3313beda4f80b7051211cb790a4f34da590a/documentation/images/cd_tutorial.gif))
    - (If you get errors on the next step -> keep reading)
    - Type this inside your terminal/console <br>`eval "$(curl -fsSL git.io/JE2Zm || wget -qO- git.io/JE2Zm)"`<br>[press enter]
    - Possible errors:
        - On MacOS, if your hard drive is encrypted on BigSur, you might need to [follow these steps](https://stackoverflow.com/questions/67115985/error-installing-nix-on-macos-catalina-and-big-sur-on-filevault-encrypted-boot-v#comment120393385_67115986)
        - On Linux, if you're running a *really* barebones system that somehow doesn't have either `curl` or `wget`, install curl or wget and rerun the previous step
- Windows users
    - Get [WSL](https://youtu.be/av0UQy6g2FA?t=91) (Windows Subsystem for Linux) or [WSL2](https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10)<br>
        - If you're not familiar with WSL, I'd recommend [watching a quick thing on it like this one](https://youtu.be/av0UQy6g2FA?t=91)
        - Ubuntu 20.04 for WSL is preferred (same as in that linked video), but Ubuntu 22.04 or similar should work.
        - [WSL2](https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10) (just released August 2020) is needed if you want to use your GPU.<br>
    - Once WSL is installed (and you have a terminal logged into WSL) follow the Mac/Linux instructions.
    - (tip: when accessing WSL, you probably want to use the VS Code terminal, or the [open source windows terminal](https://github.com/microsoft/terminal) instead of CMD)

After you've finished working and close the terminal, you can always return to project environment by doing
- `cd WHEREVER_YOU_PUT_THE_PROJECT`
- `commands/start`

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

### What is that `eval` command doing?

1. Installing nix [manual install instructions here](https://nixos.org/download.html)
2. Installing `git` (using nix) if you don't already have git
3. It clones the repository
4. It `cd`'s inside of the repo
5. Then it runs `commands/start` to enter the project environment
