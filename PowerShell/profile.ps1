
function Remove-Path([string]$path) {
    $env:Path = (($env:Path -split ';') -ne $path) -join ';'
}
function Add-PathFirst([string]$path) {
    Remove-Path $path
    if (Test-Path $path) {$env:Path = "$path;$env:Path"}
}
function Add-PathLast([string]$path) {
    Remove-Path $path
    if (Test-Path $path) {$env:Path = "$env:Path;$path"}
}

Add-PathFirst "$HOME\.dotfiles\bin\win"
Add-PathFirst "$HOME\bin"
if (Test-Path Env:\GIT_INSTALL_ROOT) {
    Add-PathLast "$Env:GIT_INSTALL_ROOT\usr\bin"
}
oh-my-posh --init --shell pwsh --config ~/.config.omp.json | Invoke-Expression
