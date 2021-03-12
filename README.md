# dotfiles
My public Linux configuration files, using the [DotBot](https://github.com/anishathalye/dotbot) framework.

I use KeePass as my password vault, and it's an important part of my environment. If you're looking at my dotfiles for inspiration, you ignore those parts.

Note that your local copy of this repo can be anywhere you like. In the instructions below, I assume it's in ~/dotfiles. 

# Bootstrap  a new environment

## A simple Linux (Debian-derived) environment:

In a shell, pull down this repository and run install:

        sudo apt install git
        git clone https://github.com/dwmuller/dotfiles.git --recursive ~/dotfiles # Use https so no creds needed yet.
        cd ~/dotfiles
        ./install

Fix problems that arise, repeat `./install`

## In a WSL2 (Debian-derived) Linux environment 
On the Windows host in a Powershell as administrator:
  - [Install chocolatey](https://chocolatey.org/install) if you haven't already, then restart your shell.
  - Install KeePass and KeeAgent:
  
        cinst keepass keepass-plugin-keegent keepass-plugin-keeanywhere keepass-plugin-keepassotp -y

  - Enable agent for Windows OpenSSH in KeeAgent options.
  - Install npiperelay utility, used to make SSH agent available in WSL 2: 

        cinst npiperelay -y

In the Linux environment:
- Install git:

        sudo apt install git

 - Pull down this repository and run install:

        export MSYS=winsymlinks:nativestrict
        git clone https://github.com/dwmuller/dotfiles.git --recursive ~/dotfiles` # Use https so no creds needed yet.
        cd ~/dotfiles
        ./install
  - Fix problems that arise, repeat `./install`

## On Windows to support Git for Windows
In a Powershell, running as administrator:
  - [Install chocolatey](https://chocolatey.org/install) if you haven't already, then restart your shell.
  - Install KeePass and KeeAgent:
  
        cinst keepass keepass-plugin-keegent keepass-plugin-keeanywhere keepass-plugin-keepassotp -y

  - Install Git for Windows:

        cinst git -y # installs Git for Windows

In Git Bash as administrator, or with [Developer Mode enabled](https://blogs.windows.com/windowsdeveloper/2016/12/02/symlinks-windows-10/), so that symlinks work:
  - Pull down this repository and run install:

        export MSYS=winsymlinks:nativestrict
        git clone https://github.com/dwmuller/dotfiles.git --recursive ~/dotfiles # Use https so no creds needed yet.
        cd ~/dotfiles
        ./install
  - Fix problems that arise, repeat `./install`

## All environments
Once SSH agent is set up and working, change the origin of this repository to use SSH instead of HTTPS, to avoid being asked for GitHub credentials:

        git remote set-url origin gh:dmuller/dotfiles


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

