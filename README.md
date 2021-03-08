# dotfiles
My public Linux configuration files, using the [DotBot](https://github.com/anishathalye/dotbot) framework.

# Bootstrap  a new environment

- Install git
- For WSL 2, on the Windows host in a privileged Powershell:
  - `cinst keepass keepass-plugin-keegent keepass-plugin-keeanywhere keepass-plugin-keepassotp -y`
  - Enable agent for Windows OpenSSH in KeeAgent options.
  - `cinst npiperelay -y`
- Clone this repo to wherever:
  - `git clone git@github.com:dwmuller/dotfiles.git --recursive`
- Install:
  - `cd dotfiles`
  - `./install`
- Address any issues (e.g. default dotfiles in the way) and repeat.
- Move on to real work.
