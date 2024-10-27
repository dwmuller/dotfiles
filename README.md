# dotfiles

My public configuration files. It takes some inspiration from the
[DotBot](https://github.com/anishathalye/dotbot) framework, although it ended up
being a custom solution to better support both Windows and various Linux
environments.

The repository should reside in ~/.dotfiles.

## Bootstrap  a new environment

### A simple Linux (Debian-derived) environment

In a shell, pull down this repository and run install:

```bash
sudo apt install git
git clone https://github.com/dwmuller/dotfiles.git --recursive ~/.dotfiles # Uses https so no creds needed yet.
cd ~/.dotfiles
./setup-bash
```

### On Windows

#### 1. Install Git for Windows

In a PowerShell session (you can use Windows PowerShell):

```ps
irm get.scoop.sh | Invoke-Expression # Installs Scoop pkg mgr
scoop install git # Installs "portable" version of Scoop
```

In order to avoid problems running the version of Bash that comes with that
installation, open Settings, search for "manage app execution aliases", find
"Windows Subsystem for Linux - bash.exe", and turn it off.

After installing Windows Terminal later, you may need to add a profile for Bash.
(The portable version is not detected automatically.) The command line should be
`bash.exe --login -i`.

#### 2. Enable symlink support

You can do this in any of three ways if you have admin access.

- Run gpedit and add your user name to Computer Configuration> Software
  Settings> Security Settings> User Rights Assignment> Create symbolic links.
- Run as administrator
- Enable [Developer Mode](https://blogs.windows.com/windowsdeveloper/2016/12/02/symlinks-windows-10/)

If you can't have admin access, skip this step. On Windows, the installation
will use junctions (for directories) and hard links (for files) instead.

#### 3. Pull down this repository and cd to it

```ps
cd $HOME
# Use https so no creds needed
git clone https://github.com/dwmuller/dotfiles.git --recurse-submodules .dotfiles
cd .dotfiles
```

#### 4. Run the one-time Windows setup script

This installs a variety of software and fonts using both winget and scoop.

```ps
cd $HOME\.dotfiles
powershell .\setup-win.ps1
```

Note that this will print out the path to a .reg file that you should run (e.g.
from Explorer) to register the Python interpreter that was installed.

#### 5. Run ./setup-bash in a Bash shell

This configures the Bash environment and some common apps:
  
```bash
cd ~/.dotfiles
./setup-bash
```

#### 6. Miscellany

Configure Windows Terminal profile defaults to use the Cascadia Mono NF font,
which was installed by setup-win.ps1. This is needed to correctly render some of
the characters used in the command line prompts generated by Oh My Posh.

## In a WSL2 (Debian-derived) Linux environment

First, install software on the Windows host, as per the previous section.

In the Linux environment, install prerequisites. A new WSL2 distro will not be
able to communicate over a VPN, so turn off any VPN on the host while you set
things up.

**Install git:**

```bash
sudo apt install git
```

**Pull down this repository:**

```bash
cd ~
git clone https://github.com/dwmuller/dotfiles.git --recursive ./.dotfiles  # Use https so no creds needed yet.
cd .dotfiles
```

If you haven't done so already, **create /etc/wsl.conf**. This contains some boot-time fixes.

```bash
sudo cp ./wsl.conf /etc/wsl.conf
```

If you had to create wsl.conf, you can start a VPN connection now, but you
must first **restart the WSL environment**. From PowerShell on the host:

```bash
wsl -t "Ubuntu"
```

Now, back in a (possibly new) WSL2 terminal:

**Run setup-bash:**

```bash
cd ~/.dotfiles
./setup-bash
```

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

To activate any changes in Bash after running './setup-bash', without restarting
the shell:

```bash
source ~/bashrc
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
that you're running ./setup-bash as admin or as a user with permission to create
symbolic links. Otherwise, setup-bash tries to use hard links for files and 
junctions for directories.

### Visual Studio Code in WSL

Usually, running ``code .`` in a WSL shell starts VSCode on Windows and exits.
If instead it pends, and you get odd git behavior, make sure you've installed the
WSL extension in VSCode.

## Historical notes

2023-06-17: I used to use KeeAgent on Windows systems to provide an ssh-agent, and a
combination of npiperelay and socat to make that agent available on WSL2.
I am transitioning instead to a more mundane approach of generating a
unique SSH key on each client, where I treat a WSL distro as a distinct client.
