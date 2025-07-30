Write-Output "=== Startup & Persistence Check ==="

# Check registry Run keys
Write-Output "`n[Registry Autoruns]"

$runKeys = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
)

foreach ($key in $runKeys) {
    try {
        $entries = Get-ItemProperty -Path $key
        if ($entries.PSObject.Properties.Count -gt 1) {
            foreach ($entry in $entries.PSObject.Properties) {
                if ($entry.Name -ne "PSPath" -and $entry.Name -ne "PSParentPath" -and $entry.Name -ne "PSChildName" -and $entry.Name -ne "PSDrive" -and $entry.Name -ne "PSProvider") {
                    Write-Output " - $($entry.Name): $($entry.Value)"
                }
            }
        } else {
            Write-Output " - No autorun entries found in $key"
        }
    } catch {
        Write-Output " - Could not access $key"
    }
}

# Check scheduled tasks
Write-Output "`n[Scheduled Tasks]"

$tasks = Get-ScheduledTask | Where-Object { $_.TaskPath -notlike "\Microsoft*" }

if ($tasks) {
    foreach ($task in $tasks) {
        Write-Output " - $($task.TaskName) at path $($task.TaskPath)"
    }
} else {
    Write-Output " - No suspicious scheduled tasks found"
}
