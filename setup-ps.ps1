if ($PSVersionTable.PSEdition -ne 'Core') {
    Write-Error "Please run this in the core version of PowerShell."
    Exit 1
}

New-Item -Force -ItemType SymbolicLink -Path $PSScriptRoot -Name "./test_symlink" -Value "." -ErrorAction SilentlyContinue > $null
$useSymlinks = if ($?) {$true} else {$false}
if ($useSymlinks) {
    Write-Host "Using symlinks."
    Remove-Item -Force "./test_symlink"
}
else {
    Write-Host "Symlinks do not work. If you continue, hard and junction links will be attempted instead."
    Read-Host "Press ENTER to continue."
}

function New-ItemLink {
    Param([string] $link, [string] $target)
    $linkPath = Split-Path -Path $link
    $linkName = Split-Path -Path $link -Leaf
    $targetItem = Get-Item -Path (Join-Path $PSScriptRoot $target -Resolve)
    if ($useSymlinks) {
        Write-Host "Creating symbolic link '$linkName' in '$linkPath' to '$targetItem'."
        New-Item -Force -ItemType SymbolicLink -Path $linkPath -Name $linkName -Value $targetItem -ErrorAction SilentlyContinue
    }
    elseif (Test-Path $target -PathType Container) {
        Write-Host "Creating junction '$linkName' in '$linkPath' to '$targetItem'."
        New-Item -Force -ItemType Junction -Path $linkPath -Name $linkName -Value $targetItem
    }
    else {
        Write-Host "Creating hard link '$linkName' in '$linkPath' to '$targetItem'."
        New-Item -Force -ItemType HardLink -Path $linkPath -Name $linkName -Value $targetItem
    }
}

# Set up a profile to use in all hosts.
New-ItemLink $PROFILE.CurrentUserAllHosts PowerShell/profile.ps1
