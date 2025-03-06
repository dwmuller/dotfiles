

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

oh-my-posh --init --shell pwsh --config ~/.config.omp.json | Invoke-Expression

# Convenient online help invocation, since PS lacks a text-based pager.
function Get-HelpOnline {Get-Help -Online @args}
New-Alias -Name ohelp -Value Get-HelpOnline

# Or maybe we can haz pager ...
&{
    $local:P="$env:LOCALAPPDATA\Programs\Git\usr\bin\less.exe"
    if (Test-Path -Path $local:P) {
        $Env:PAGER=$local:P
    }
}