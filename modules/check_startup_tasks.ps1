Write-Output "=== Startup & Persistence Check ==="

# -------------------------------
# Check Registry Autoruns
# -------------------------------
Write-Output "`n[Registry Autoruns]"

$runKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
)

foreach ($key in $runKeys) {
    try {
        if (Test-Path $key) {
            $entries = Get-ItemProperty -Path $key
            $props = $entries.PSObject.Properties |
                Where-Object { $_.Name -notin @("PSPath","PSParentPath","PSChildName","PSDrive","PSProvider") }

            if ($props.Count -gt 0) {
                foreach ($entry in $props) {
                    Write-Output " - [$key] $($entry.Name): $($entry.Value)"
                }
            } else {
                Write-Output " - No autorun entries found in $key"
            }
        } else {
            Write-Output " - Registry key $key does not exist"
        }
    } catch {
        Write-Output " - Could not access $key"
    }
}

# -------------------------------
# Check Scheduled Tasks
# -------------------------------
Write-Output "`n[Scheduled Tasks]"

try {
    $tasks = Get-ScheduledTask | Where-Object { $_.TaskPath -notlike "\Microsoft*" }

    if ($tasks -and $tasks.Count -gt 0) {
        foreach ($task in $tasks) {
            Write-Output " - Task: $($task.TaskName) | Path: $($task.TaskPath)"
        }
    } else {
        Write-Output " - No suspicious scheduled tasks found"
    }
} catch {
    Write-Output " - Failed to enumerate scheduled tasks"
}
