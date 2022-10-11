# dotfiles

My public Linux configuration files, using the
[DotBot](https://github.com/anishathalye/dotbot) framework.

I use KeePass as my password vault, and it's an important part of my
environment. If you're looking at my dotfiles for inspiration, you can ignore or
adapts those parts. You may want to come up with a different scheme for setting
up ssh-agent, or you may use other authentication methods.

Note that your local copy of this repo can be anywhere you like. In the
instructions below, I assume it's in ~/dotfiles. 

# Bootstrap  a new environment

## A simple Linux (Debian-derived) environment:

In a shell, pull down this repository and run install:

        sudo apt install git
        git clone https://github.com/dwmuller/dotfiles.git --recursive ~/dotfiles # Use https so no creds needed yet.
        cd ~/dotfiles
        ./install

Fix problems that arise, repeat `./install`

## On Windows, to support Git for Windows and WSL2

In a Powershell, running as administrator:

- [Install chocolatey](https://chocolatey.org/install):

        Set-ExecutionPolicy Bypass -Scope Process -Force;
        if (-not (Get-Command "choco.exe" -ErrorAction SilentlyContinue)) {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        }

- Restart your PowerShell
- Install Git for Windows:

        choco install git -y # installs Git for Windows

In Git Bash as administrator, or with [Developer Mode
enabled](https://blogs.windows.com/windowsdeveloper/2016/12/02/symlinks-windows-10/),
so that symlinks work:

- Pull down this repository and cd to it:

        mkdir -p ~/projects/dwmuller
        cd ~/projects/dwmuller
        git clone https://github.com/dwmuller/dotfiles.git --recursive ~/dotfiles  # Use https so no creds needed
        cd dotfiles

- Run the one-time setup script to install some stuff:

        powershell ./setup-win.ps1

- Run ./install to install dotfiles:
  
        export MSYS=winsymlinks:nativestrict  # Use Windows symlinks, fail if not available
        cd ~/dotfiles
        ./install
  
- Fix problems that arise, repeat `./install`


**Note:** Use Bash to run the install script, not PowerShell. I am considering
using the dotbot-crossplatform plugin to make Windows support more robut, but
for now the installation configuration relies on having a bash-like shell to
test for directory existence.

## In a WSL2 (Debian-derived) Linux environment 

First, install software on the Windows host, as per the previous section.

In the Linux environment, install prerequisites. A new WSL2 distro will not be
able to communicate over a VPN, so turn off the VPN while you set things up.

- Install git:

        sudo apt install git

- Pull down this repository:

        mkdir -p ~/projects/dwmuller
        cd ~/projects/dwmuller
        git clone https://github.com/dwmuller/dotfiles.git --recursive ~/dotfiles  # Use https so no creds needed yet.
        cd dotfiles

- If you haven't done so already, create /etc/wsl.conf. This contains some boot-time fixes.

        sudo cp ./wsl.conf /etc/ws.conf

If you had to create wsl.conf, you can start the VPN connection now, but you
have to restart the WSL environment. From PowerShell on the host:

        wsl -t "Ubuntu"

Now, back in a (possibly new) WSL2 terminal:
- Run install:

        cd ~/projects/dwmuller/dotfiles
        ./install

Fix any problems that arise, and repeat `./install`

## All environments

Once SSH agent is set up and working, change the origin of this repository to
use SSH instead of HTTPS, to avoid being asked for GitHub credentials. (Note
that this uses a URL alias for GitHub, defined in my .gitconfig.)

        git remote set-url origin gh:dwmuller/dotfiles

To activate any changes in Bash after running './install', without restarting
the shell:

        . ~/bashrc

# To-do list

- Local overrides
- Consider .bash_logout
- Consider adopting additional config files/directories (ongoing)
  - VS Code
  - vim
  - emacs

# Notes on specific files or directories

## config.xlaunch

Configuration for the XLaunch X server for Windows, which you can install using
Chocolatey. Set up a shortcut using this Target:

```
"C:\Program Files\VcXsrv\xlaunch.exe" -run "C:\Users\danm\dotfiles\config.xlaunch"
```

## wsl.conf

Fixes the inability to route WSL 2 traffic through a host's VPN connection.

# To do

## Automate one-time installation of OS packages

Maybe using a dotbot plugin?

Packages installed in WSL Ubuntu while resurrecting my Emacs
environment:

- emacs
- emacs-common-non-dfsg, for Emacs documentation

See also [setup-win.ps1](./setup-win.ps1).

# Troubleshooting

## WSL2: Git doesn't seem to read file modes correctly

Make sure that you've installed git in the Linux subsystem, and that you aren't
accidentally running Git for Windows. Use `which git` to check where you're
getting git from. 

## WSL2: ssh-agent forwarding is not working (wsl-ssh-agent)

Could be any number of things. Test using an ssh connection to a system set up
to accept a cert. Make sure that KeeAnywhere options have the (experimental)
Windows OpenSSH support enabled. (By default, it's not.) wsl-ssh-agent takes a
-d argument to kill all extant pipes, and then runs one with verbose output to
the current process. Using -v with ssh also gives some information about its
attempts to connect to the agent.

## Git for Windows: Links fail during install

Check to make sure that MSYS is defined as described in the instructions, and
that you're running ./install as admin.

