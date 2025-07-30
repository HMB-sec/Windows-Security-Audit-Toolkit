Write-Output "=== Unquoted Service Path Scanner ==="

$services = Get-WmiObject win32_service | Where-Object { $_.StartMode -eq "Auto" }
$found = $false

foreach ($svc in $services) {
    $path = $svc.PathName
    if ($path -and $path -notlike '"*' -and $path -match '\s') {
        if ($path -notmatch '^C:\\Windows') {
            Write-Output "WARNING: $($svc.Name) - $path"
            $found = $true
        }
    }
}

if (-not $found) {
    Write-Output "No unquoted service paths found."
}
