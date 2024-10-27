 # Get the ID and security principal of the current user account
 $myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
 $myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
  
 # Get the security principal for the Administrator role
 $adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
  
 # Check to see if we are currently running "as Administrator"
 if ($myWindowsPrincipal.IsInRole($adminRole)) {
    # We are running "as Administrator" - change the title to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    clear-host
 } else {
    Write-Host "Running as non-admin."
    # # We are not running "as Administrator" - so relaunch as administrator
    
    # # Create a new process object that starts PowerShell
    # $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    
    # # Specify the current script path and name as a parameter
    # $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    
    # # Indicate that the process should be elevated
    # $newProcess.Verb = "runas";
    
    # # Start the new process
    # [System.Diagnostics.Process]::Start($newProcess);
    
    # # Exit from the current, unelevated, process
    # exit
}  

function Install-PackagesUsingWinget {
    Param([string[]] $pkgs)
    # winget downloads and installs even if a package is already installed,
    # so check first. Also, winget can only install one program per invocation.
    foreach ($pkg in $pkgs) {
        winget list --accept-source-agreements --exact -q $pkg | Out-Null
        if ($?) {
            Write-Host "Already installed (winget): $pkg"
        } else {
            Write-Host "Installing (winget): $pkg"
            winget install --exact --silent  --accept-package-agreements $pkg --scope user
        }
    }
}

# We use winget by preference.
Install-PackagesUsingWinget gerardog.gsudo, JanDeDobbeleer.OhMyPosh,
    Microsoft.PowerShell, Microsoft.WindowsTerminal, albertony.npiperelay,
    Microsoft.VisualStudioCode Microsoft.PowerToys,
    Mozilla.Firefox

# Install Scoop.
#
# I switched to Scoop from Chocolatey because Scoop reputedly prefers portable versions of apps
# and does a better job of installing without admin privs.
if (!(Get-Command Scoop -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    scoop bucket add extras
    scoop bucket add nerd-fonts
}

scoop install keepass keepass-plugin-keeanywhere keepass-plugin-keepasshttp keepass-plugin-keetraytotp
scoop install Cascadia-Code
scoop install python # Note the .reg file which must be run after this installation.

Read-Host "Press ENTER to continue"
