 # Get the ID and security principal of the current user account
 $myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
 $myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
  
 # Get the security principal for the Administrator role
 $adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
  
 # Check to see if we are currently running "as Administrator"
 if ($myWindowsPrincipal.IsInRole($adminRole))
    {
    # We are running "as Administrator" - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"
    clear-host
    }
 else
    {
    # We are not running "as Administrator" - so relaunch as administrator
    
    # Create a new process object that starts PowerShell
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    
    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    
    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";
    
    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);
    
    # Exit from the current, unelevated, process
    exit
    }
  

function winget-install {
    # winget downloads and installs even if a package is already installed.
    $needed = @()
    foreach ($pkg in $args) {
        $listApp = winget list --exact -q $pkg
        if (![String]::Join("", $listApp).Contains($pkg)) {
            $needed += $pkg
        }
    }
    $notNeeded = $args | Where-Object { $_ -notin $needed} 
    Write-Host "Already installed: " @notNeeded
    if ($needed.Count -ne 0) {
        winget install --exact --silent @needed 
    }
}

function choco-install {
    # Chocolatey prints annoying warnings if pkg already installed.
    $installed = (choco list --local --idonly --limitoutput)
    $needed = $args | Where-Object { $_ -notin  $installed}
    $notNeeded = $args | Where-Object { $_ -notin $needed} 
    Write-Host "Already installed: " @notNeeded
    if ($needed.Count -ne 0) {
        choco install @needed -y --limitoutput
    }
}


# Install chocolatey.
Set-ExecutionPolicy Bypass -Scope Process -Force;
if (-not (Get-Command "choco.exe" -ErrorAction SilentlyContinue)) {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
# We use chocolatey by preference, but resort to winget if a package is
# available only there, or is kept more up to date there, or if it's
# a Microsoft tool.

choco-install git cascadia-code-nerd-font gsudo keepass keepass-plugin-keeanywhere keepass-plugin-keepassotp npiperelay
winget-install JanDeDobbeleer.OhMyPosh Microsoft.PowerShell Microsoft.WindowsTerminal Microsoft.OneDrive

# Also needed: KeeAgent plugin

Read-Host "Press ENTER to continue"