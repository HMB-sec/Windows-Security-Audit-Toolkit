Write-Output "=== Patch & Update Status ==="

try {
    $hotfixes = Get-HotFix | Sort-Object -Property InstalledOn -Descending

    if ($hotfixes.Count -eq 0) {
        Write-Output "WARNING: No hotfixes found. System may not be updated."
    } else {
        Write-Output "`nRecent Hotfixes Installed:"
        foreach ($fix in $hotfixes[0..4]) {
            Write-Output " - $($fix.HotFixID) installed on $($fix.InstalledOn)"
        }

        $lastPatch = $hotfixes[0].InstalledOn
        $daysOld = (Get-Date) - $lastPatch

        if ($daysOld.Days -gt 30) {
            Write-Output "`nWARNING: Last patch was $($daysOld.Days) days ago"
        } else {
            Write-Output "`nSystem appears up to date (last patch $($daysOld.Days) days ago)"
        }
    }
} catch {
    Write-Output "ERROR: Unable to retrieve patch status - $($_.Exception.Message)"
}
