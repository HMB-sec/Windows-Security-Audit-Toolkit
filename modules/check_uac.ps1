Write-Output "=== UAC & Privilege Escalation Checks ==="

# Check UAC Status
$uacStatus = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA
if ($uacStatus.EnableLUA -eq 1) {
    Write-Output "UAC is ENABLED: PASS"
} else {
    Write-Output "UAC is DISABLED: FAIL (Potential security risk)"
}

# Check AlwaysInstallElevated
$aiHKCU = Get-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Installer" -Name AlwaysInstallElevated -ErrorAction SilentlyContinue
$aiHKLM = Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Installer" -Name AlwaysInstallElevated -ErrorAction SilentlyContinue

if ($aiHKCU.AlwaysInstallElevated -eq 1 -and $aiHKLM.AlwaysInstallElevated -eq 1) {
    Write-Output "AlwaysInstallElevated: FAIL (Privilege Escalation Risk)"
} else {
    Write-Output "AlwaysInstallElevated: PASS"
}
