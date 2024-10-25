if ($PSVersionTable.PSEdition -ne 'Core') {
    Write-Error "Please run this in the core version of PowerShell."
    Exit 1
}

New-Item -Force -ItemType SymbolicLink -Path $PSScriptRoot -Name "./test_symlink" -Value "." -ErrorAction SilentlyContinue > $null
$useSymlinks = if ($?) {$true} else {$false}
if ($useSymlinks) {
    Remove-Item -Force "./test_symlink"
}

function New-ItemLink {
    Param([string] $link, [string] $target)
    $linkPath = Split-Path -Path $link
    $linkName = Split-Path -Path $link -Leaf
    $targetItem = Get-Item -Path (Join-Path $PSScriptRoot $target -Resolve)
    if ($useSymlinks) {
        New-Item -Force -ItemType SymbolicLink -Path $linkPath -Name $linkName -Value $targetItem -ErrorAction SilentlyContinue
    }
    elseif (Test-Path $target -PathType Container) {
        New-Item -Force -ItemType Junction -Path $linkPath -Name $linkName -Value $targetItem
    }
    else {
        New-Item -Force -ItemType HardLink -Path $linkPath -Name $linkName -Value $targetItem
    }
}

New-ItemLink $PROFILE.CurrentUserCurrentHost Microsoft.PowerShell_profile.ps1