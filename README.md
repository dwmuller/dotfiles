# dotfiles

My public Linux configuration files, using the
[DotBot](https://github.com/anishathalye/dotbot) framework.

Note that your local copy of this repo can be anywhere you like. In the
instructions below, I assume it's in ~/dotfiles.

## Bootstrap  a new environment

### A simple Linux (Debian-derived) environment

In a shell, pull down this repository and run install:

```bash
sudo apt install git
git clone https://github.com/dwmuller/dotfiles.git --recursive ~/dotfiles # Use https so no creds needed yet.
cd ~/dotfiles
./install
```

Fix problems that arise, repeat `./install`

### On Windows, to support Git for Windows

In a Powershell, running as administrator, perform the following steps.

**[Install chocolatey](https://chocolatey.org/install):**

```ps
Set-ExecutionPolicy Bypass -Scope Process -Force;
if (-not (Get-Command "choco.exe" -ErrorAction SilentlyContinue)) {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
```

**Restart your PowerShell.**

**Install Git for Windows:**

```bash
choco install git -y # installs Git for Windows
```

**Install or update winget**, Microsoft's nascent package manager. Find it in the Microsoft Store under the name "App Installer".

**Enable symlink support.** You can do this in any one of three ways:

- Run gpedit and add your user name to Computer Configuration> Software Settings> Security Settings> User Rights Assignment> Create symbolic links.
- Run as administrator
- Enable [Developer Mode](https://blogs.windows.com/windowsdeveloper/2016/12/02/symlinks-windows-10/)

**Pull down this repository and cd to it:**

```bash
mkdir -p ~/projects/dwmuller
cd ~/projects/dwmuller
# Use https so no creds needed
git clone https://github.com/dwmuller/dotfiles.git --recurse-submodules ./dotfiles  
cd dotfiles
```

**Run the one-time setup script** to install some stuff:

```bash
powershell ./setup-win.ps1
```

**Run ./install** to install dotfiles:
  
```bash
export MSYS=winsymlinks:nativestrict  # Use Windows symlinks, fail if not available
cd ~/projects/dotfiles
./install
```

Fix any problems that arise, repeat `./install`

**Note:** Use Bash to run the install script, not PowerShell. I am considering
using the dotbot-crossplatform plugin to make Windows support more robust, but
for now the installation configuration relies on having a bash-like shell to
test for directory existence.

## In a WSL2 (Debian-derived) Linux environment

First, install software on the Windows host, as per the previous section.

In the Linux environment, install prerequisites. A new WSL2 distro will not be
able to communicate over a VPN, so turn off the VPN while you set things up.

**Install git:**

```bash
sudo apt install git
```

**Pull down this repository:**

```bash
mkdir -p ~/projects/dwmuller
cd ~/projects/dwmuller
git clone https://github.com/dwmuller/dotfiles.git --recursive ./dotfiles  # Use https so no creds needed yet.
cd dotfiles
```

If you haven't done so already, **create /etc/wsl.conf**. This contains some boot-time fixes.

```bash
sudo cp ./wsl.conf /etc/wsl.conf
```

If you had to create wsl.conf, you can start the VPN connection now, but you
must first **restart the WSL environment**. From PowerShell on the host:

```bash
wsl -t "Ubuntu"
```

Now, back in a (possibly new) WSL2 terminal:

**Run install:**

```bash
cd ~/projects/dwmuller/dotfiles
./install
```

Fix any problems that arise, and repeat `./install`

## All environments

Generate an SSH key unique to this environment:

```bash
ssh-keygen -t ecdsa
```

In WSL environments, add ``-C danm@*distro*@*windows-hostname*``. (The default comment
is *username*@*hostname*).

Add the public part of the key to your GitHub account (and anywhere else you plan
to connect).

Set up ssh-agent if you need it. Verify authenticaction to GitHub:

```bash
ssh -T git@github.com
```

That should generate a message that includes your GitHub user name.

Now change the origin of this repository to
use SSH instead of HTTPS, to avoid being asked for GitHub credentials. (Note
that this uses a URL alias for GitHub, defined in my .gitconfig.)

```bash
git remote set-url origin gh:dwmuller/dotfiles
```

To activate any changes in Bash after running './install', without restarting
the shell:

```bash
. ~/bashrc
```

## To-do

- Local overrides
- Consider adopting additional config files/directories (ongoing)
  - VS Code
  - vim
  - emacs

## Notes on specific files or directories

### config.xlaunch

Configuration for the XLaunch X server for Windows, which you can install using
Chocolatey. Set up a shortcut using this Target:

```ps
"C:\Program Files\VcXsrv\xlaunch.exe" -run "C:\Users\danm\dotfiles\config.xlaunch"
```

### wsl.conf

Fixes the inability to route WSL 2 traffic through a host's VPN connection.

## Troubleshooting

### QT5 apps (like KeePassXC) scale incorrectly on some displays

(Experimental.) On Windows systems where this is an issue, set the environment
variable QT_AUTO_SCREEN_SCALE_FACTOR=1.

### WSL2: Git doesn't seem to read file modes correctly

Make sure that you've installed git in the Linux subsystem, and that you aren't
accidentally running Git for Windows. Use `which git` to check where you're
getting git from.

### WSL2: ssh-agent forwarding is not working (wsl-ssh-agent)

Could be any number of things. Test using an ssh connection to a system set up
to accept a cert. Make sure that KeeAnywhere options have the (experimental)
Windows OpenSSH support enabled. (By default, it's not.) wsl-ssh-agent takes a
-d argument to kill all extant pipes, and then runs one with verbose output to
the current process. Using -v with ssh also gives some information about its
attempts to connect to the agent.

### Git for Windows: Links fail during install

Check to make sure that MSYS is defined as described in the instructions, and
that you're running ./install as admin.

### Visual Studio Code in WSL

Usually, running ``code .`` in a WSL shell starts VSCode on Windows and exits.
If instead it pends, and you get odd git behavior, make sure you've installed the
WSL extension in VSCode.

## Historical notes

2023-06-17: I used to use KeeAgent on Windows systems to provide an ssh-agent, and a
combination of npiperelay and socat to make that agent available on WSL2.
I am transitioning instead to a more mundane approach of generating a
unique SSH key on each client, where I treat a WSL distro as a distinct client.
