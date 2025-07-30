Write-Output "=== Windows Defender & AV Status Checks ==="

# Check if Windows Defender is running
$defenderService = Get-Service -Name "WinDefend" -ErrorAction SilentlyContinue
if ($defenderService.Status -eq "Running") {
    Write-Output "Windows Defender Status: PASS"
} else {
    Write-Output "Windows Defender Status: FAIL (Not running)"
}

# Check if real-time protection is enabled
$realtimeStatus = Get-MpPreference | Select-Object -ExpandProperty DisableRealtimeMonitoring
if ($realtimeStatus -eq $false) {
    Write-Output "Real-Time Protection: PASS"
} else {
    Write-Output "Real-Time Protection: FAIL (Disabled)"
}

# Check for exclusions
$exclusions = Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
if ($exclusions.Count -gt 0) {
    Write-Output "Defender Exclusions: WARNING (Exclusions present)"
    foreach ($path in $exclusions) {
        Write-Output " - $path"
    }
} else {
    Write-Output "Defender Exclusions: PASS (No exclusions set)"
}
