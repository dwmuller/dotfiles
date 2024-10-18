$binroot = "$env:HOMEDRIVE$env:HOMEPATH"
$binpath = "$binroot\bin;$binroot\.dotfiles\bin\win"
if (! $env:Path.StartsWith($binpath)) {$env:Path = $binpath + ';' + $env:Path}

oh-my-posh --init --shell pwsh --config ~/.config.omp.json | Invoke-Expression