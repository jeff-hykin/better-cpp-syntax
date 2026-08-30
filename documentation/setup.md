# Setup The Project Environment

Linux and MacOS Users, run the following in your terminal and it'll step you through setup

```
repo=git@github.com:jeff-hykin/better-cpp-syntax.git defaultNixVersion=2.18.1 eval "$(curl -fsSL https://raw.githubusercontent.com/jeff-hykin/xome/refs/heads/master/setup.sh || wget -qO- https://raw.githubusercontent.com/jeff-hykin/xome/refs/heads/master/setup.sh)"
```

Windows Users, install WSL and Ubuntu 20.04 or Ubuntu 22.04 and then run the command above in that terminal

### If you don't want to run the script

Good! You probably shouldn't be running random internet scripts. Here's how you can do it yourself:

```sh
# install nix
curl -L https://nixos.org/nix/install | sh
# clone this repo somewhere
git clone https://github.com/jeff-hykin/better-cpp-syntax.git
# cd into the repo
cd better-cpp-syntax
# run nix develop
nix develop
```

Once you're in there you can run `run/build` and `run/test` to build and test the project. This project is managed by [xome](https://github.com/jeff-hykin/xome)
