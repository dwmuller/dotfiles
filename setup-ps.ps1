if ($PSVersionTable.PSEdition -ne 'Core') {
    Write-Error "Please run this in the core version of PowerShell."
    Exit 1
}

$User = [Security.Principal.WindowsIdentity]::GetCurrent();
$isAdmin = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  

function New-ItemLink {
    Param([string] $link, [string] $target)
    $linkPath = Split-Path -Path $link
    $linkName = Split-Path -Path $link -Leaf
    $targetItem = Get-Item -Path (Join-Path $PSScriptRoot $target -Resolve)
    if ($isAdmin) {
        New-Item -Force -ItemType SymbolicLink -Path $linkPath -Name $linkName -Value $targetItem
    }
    elseif (Test-Path $target -PathType Container) {
        New-Item -Force -ItemType Junction -Path $linkPath -Name $linkName -Value $targetItem
    }
    else {
        New-Item -Force -ItemType HardLink -Path $linkPath -Name $linkName -Value $targetItem
    }
}

New-ItemLink $PROFILE.CurrentUserCurrentHost Microsoft.PowerShell_profile.ps1