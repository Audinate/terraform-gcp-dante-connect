Write-Output "Disabling Windows Update service..."

$WindowsUpdatePath = "HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\"
$AutoUpdatePath = "HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

If (Test-Path -Path $WindowsUpdatePath) {
    Remove-Item -Path $WindowsUpdatePath -Recurse
}

New-Item $WindowsUpdatePath -Force
New-Item $AutoUpdatePath -Force

Set-ItemProperty -Path $AutoUpdatePath -Name NoAutoUpdate -Value 1

Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" | Disable-ScheduledTask

takeown /F C:\Windows\System32\Tasks\Microsoft\Windows\UpdateOrchestrator /A /R
icacls C:\Windows\System32\Tasks\Microsoft\Windows\UpdateOrchestrator /grant Administrators:F /T

Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" | Disable-ScheduledTask

Stop-Service wuauserv
Set-Service wuauserv -StartupType Disabled

Write-Output "Windows Update service disabled"
