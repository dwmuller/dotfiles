# Fix Bluetooth connection to headset.
#
# A scripted version of what I've found to work reliably when performed
# "manually".

# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator') -or
         ($PSVersionTable.PSVersion.Major -gt 5)) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
     $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
     Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
     Exit
    }
}

# Jury's still out as to whether BT needs to be toggled as part of this
# workaround.

function Bluetooth {
    param (
        [Parameter(Mandatory=$true)][ValidateSet('Off', 'On')][string]$BluetoothStatus
    )

    # This requires the older, Windows-specific version of PowerShell. Newer
    # versions are based on .NET core which does not include the
    # WindowsRuntimeExtensions. That's the reason for the call to New-PSSession.
    # At the top of this script we make sure to both elevate to admin, and to
    # run the PS version we need.
    #
   
    If ((Get-Service bthserv).Status -eq 'Stopped') { Start-Service bthserv }
    Add-Type -AssemblyName System.Runtime.WindowsRuntime
    $asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | 
        Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
    Function Await($WinRtTask, $ResultType) {
        $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
        $netTask = $asTask.Invoke($null, @($WinRtTask))
        $netTask.Wait(-1) | Out-Null
        $netTask.Result
    }
    [Windows.Devices.Radios.Radio,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
    [Windows.Devices.Radios.RadioAccessStatus,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
    Await ([Windows.Devices.Radios.Radio]::RequestAccessAsync()) ([Windows.Devices.Radios.RadioAccessStatus]) | Out-Null
    $radios = Await ([Windows.Devices.Radios.Radio]::GetRadiosAsync()) ([System.Collections.Generic.IReadOnlyList[Windows.Devices.Radios.Radio]])
    $bluetooth = $radios | Where-Object { $_.Kind -eq 'Bluetooth' }
    [Windows.Devices.Radios.RadioState,Windows.System.Devices,ContentType=WindowsRuntime] | Out-Null
    Await ($bluetooth.SetStateAsync($BluetoothStatus)) ([Windows.Devices.Radios.RadioAccessStatus]) | Out-Null
}

function Wait ($activity, $secondsLeft) {
    while ($secondsLeft-- -gt 0) {
        Write-Progress -Activity $activity -SecondsRemaining $secondsLeft
        Start-Sleep 1
    }
}
# The delays seem necessary, although they could probably be tweaked.
Write-Progress -Activity "Turning Bluetooth off ..." 
Bluetooth Off
#Start-Sleep 2
Write-Progress -Activity "Restarting Bluetooth Support Service ..."
$svc = Restart-Service -Name "Bluetooth Support Service" -Force -PassThru
$attempt = 1
do {
    Write-Progress "Confirming service restart ..." -Status "Attempt $attempt" 
    Start-Sleep 1
} until ($svc.Status -eq "Running")
Wait "Waiting for service to settle before turning Bluetooth on ..." 8
Bluetooth On
Write-Host "Bluetooth started. Give devices some time to reconnect."
Read-Host -Prompt "Press Enter to exit"
