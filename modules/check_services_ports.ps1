Write-Output "=== Running Services & Open Ports Check ==="

# Running services
Write-Output "`n[Running Services]"
$running = Get-Service | Where-Object { $_.Status -eq 'Running' }

foreach ($service in $running) {
    Write-Output " - $($service.Name): $($service.DisplayName)"
}

# Open ports and listeners
Write-Output "`n[Open Network Ports]"

try {
    $netstat = netstat -ano | Select-String "LISTENING"
    $lines = $netstat -replace "\s+", "," | ForEach-Object {
        $parts = $_.Split(",")
        if ($parts.Count -ge 5) {
            "$($parts[1]) listening on $($parts[2]) (PID $($parts[4]))"
        }
    }

    $lines | Sort-Object -Unique | ForEach-Object { Write-Output " - $_" }
} catch {
    Write-Output "ERROR: Could not parse open ports."
}
