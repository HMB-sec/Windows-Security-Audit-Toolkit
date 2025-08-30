Write-Output "=== Unquoted Service Path Scanner ==="

try {
    # Get all auto-start services
    $services = Get-WmiObject Win32_Service | Where-Object { $_.StartMode -eq "Auto" }
    $found = $false

    foreach ($svc in $services) {
        $path = $svc.PathName

        if ($path -and $path -notlike '"*' -and $path -match '\s') {
            # Ignore core Windows paths (safe ones)
            if ($path -notmatch '^C:\\Windows') {
                Write-Output "WARNING: Unquoted service path found -> Service: $($svc.Name) | Path: $path"
                $found = $true
            }
        }
    }

    if (-not $found) {
        Write-Output "No unquoted service paths found. PASS"
    }
} catch {
    Write-Output "Error: Could not enumerate services."
}
