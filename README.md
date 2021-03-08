# dotfiles
My public Linux configuration files, using the [DotBot](https://github.com/anishathalye/dotbot) framework.

I use KeePass as my password vault, and it's an important part of my environment. If you're looking at my dotfiles for inspiration, you ignore those parts.

Note that your local copy of this repo can be anywhere you like. In the instructions below, I assume it's in ~/dotfiles. 

# Bootstrap  a new environment

## A simple Linux (Debian-derived) environment:

  - `sudo apt install git`
  - `git clone https://github.com/dwmuller/dotfiles.git --recursive ~/dotfiles` # Use https so no creds needed yet.
  - `cd ~/dotfiles`
  - `./install`
  - Fix problems that arise, repeat `./install`

## In a WSL2 (Debian-derived) Linux environment 
- On the Windows host in a privileged Powershell:
  - [Install chocolatey](https://chocolatey.org/install) if you haven't already, then restart your shell.
  - `cinst keepass keepass-plugin-keegent keepass-plugin-keeanywhere keepass-plugin-keepassotp -y`
  - Enable agent for Windows OpenSSH in KeeAgent options.
  - `cinst npiperelay -y`
- In the Linux environment, Install git in the Linu environment:
  - `sudo apt install git`
  - `git clone https://github.com/dwmuller/dotfiles.git --recursive ~/dotfiles` # Use https so no creds needed yet.
  - `cd ~/dotfiles`
  - `./install`
  - Fix problems that arise, repeat `./install`

## On Windows to support Git for Windows
-In a privileged Powershell:
  - [Install chocolatey](https://chocolatey.org/install) if you haven't already, then restart your shell.
  - `cinst keepass keepass-plugin-keegent keepass-plugin-keeanywhere keepass-plugin-keepassotp -y`
  - `cinst git -y` # installs Git for Windows
  - Run Git Bash as administrator (needed to create symlinks)
  - `export MSYS=winsymlinks:nativestrict`
  - `git clone https://github.com/dwmuller/dotfiles.git --recursive ~/dotfiles` # Use https so no creds needed yet.
  - `cd ~/dotfiles`
  - `./install`
  - Fix problems that arise, repeat `./install`

Note: The MSYS variable will henceforth be set by my dotfiles, but you will still have to update installs from an admin shell.


# To-do list

- Local overrides
- Look for additional dot files/directories
- Do we like the prompt that we cribbed?
- Consider .bash_logout

# Troubleshooting

## WSL2: Git doesn't seem to read file modes correctly

Make sure that you've installed git in the Linux subsystem, and that you aren't accidentally running Git for Windows. Use `which git` to check where you're getting git from. 

## WSL2: ssh-agent forwarding is not working (wsl-ssh-agent)
Could be any number of things. Test using an ssh connection to a system set up to accept a cert. Make sure that KeeAnywhere options have the (experimental) Windows OpenSSH support enabled. (By default, it's not.) wsl-ssh-agent takes a -d argument to kill all extant pipes, and run one with verbose output to the current process. Using -v with ssh also gives some information about its attempt to connect to the agent.

## Git for Windows: Links fail during install

Check to make sure that MSYS is defined as described in the instructions, and that you're running ./install as admin.

