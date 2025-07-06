# Delete the registry key controlling KFX downloads.
$key = 'HKCU:\SOFTWARE\Amazon\Kindle\User Settings'
$prop = 'isKRFDRendererSupported'
if  (Get-ItemProperty $key -Name isKRFDRendererSupported -ErrorAction Ignore) {
    Write-Host "Removing $prop."
    Remove-ItemProperty $key -Name $prop -Force
}

# Start K4PC from the default location or admin install location.
$KINDLE_LOCAL="$env:LocalAppData\Amazon\Kindle\application\kindle.exe"
$KINDLE_GLOBAL="$env:ProgramFiles(X86)\Amazon\Kindle\Kindle.exe"
if (Test-Path $KINDLE_LOCAL) {
    Write-Host 'Starting from LocalAppData.'
    Start-Process $KINDLE_LOCAL 
}
elseif (Test-Path $KINDLE_GLOBAL) {
    Write-Host 'Starting from Program Files (x86).'
    Start-Process $KINDLE_GLOBAL
}
else {
    throw 'Could not start Kindle4PC from either typical location.'
}

while ( -not (Get-ItemProperty $key -Name $prop -ErrorAction Ignore))
{
    Write-Host 'Waiting ...'
    Start-Sleep -Seconds 2
}
Write-Host "Clearing $prop."
Set-ItemProperty $key -Name $prop -Value 'false'
