Write-Output "=== UAC & Privilege Escalation Checks ==="

# --- UAC Status ---
try {
    $uacStatus = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name EnableLUA -ErrorAction Stop
    if ($uacStatus.EnableLUA -eq 1) {
        Write-Output "UAC is ENABLED: PASS"
    } else {
        Write-Output "UAC is DISABLED: FAIL (Potential security risk)"
    }
} catch {
    Write-Output "Could not retrieve UAC status."
}

# --- AlwaysInstallElevated Policy ---
try {
    $aiHKCU = Get-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Installer" -Name AlwaysInstallElevated -ErrorAction SilentlyContinue
    $aiHKLM = Get-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Installer" -Name AlwaysInstallElevated -ErrorAction SilentlyContinue

    if ($aiHKCU.AlwaysInstallElevated -eq 1 -and $aiHKLM.AlwaysInstallElevated -eq 1) {
        Write-Output "AlwaysInstallElevated: FAIL (Privilege Escalation Risk)"
    } else {
        Write-Output "AlwaysInstallElevated: PASS"
    }
} catch {
    Write-Output "Could not check AlwaysInstallElevated settings."
}
