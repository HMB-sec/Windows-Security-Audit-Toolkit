Write-Output "=== Running Services & Open Ports Check ==="

# =========================
# Running services
# =========================
Write-Output "`n[Running Services]"

try {
    # List all running services
    $runningServices = Get-Service | Where-Object { $_.Status -eq 'Running' }

    foreach ($service in $runningServices) {
        Write-Output " - $($service.Name): $($service.DisplayName)"
    }
} catch {
    Write-Output "ERROR: Could not retrieve running services."
}

# =========================
# Open ports and listeners
# =========================
Write-Output "`n[Open Network Ports]"

try {
    $connections = Get-NetTCPConnection -State Listen -ErrorAction Stop

    foreach ($conn in $connections) {
        # Get process info for the owning PID
        $proc = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
        $procName = if ($proc) { $proc.ProcessName } else { "Unknown" }

        Write-Output " - $($conn.LocalAddress):$($conn.LocalPort) (PID $($conn.OwningProcess) - $procName)"
    }
} catch {
    Write-Output "ERROR: Could not retrieve open ports."
}
