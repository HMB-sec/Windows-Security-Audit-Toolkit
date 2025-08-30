Write-Output "=== Patch Status Check ==="

try {
    # Get all installed hotfixes and filter out invalid InstalledOn entries
    $hotfixes = Get-HotFix | Where-Object { $_.InstalledOn -is [datetime] }

    if ($hotfixes.Count -eq 0) {
        Write-Output "No hotfix information available."
    }
    else {
        $latestPatch = $hotfixes | Sort-Object InstalledOn -Descending | Select-Object -First 1
        Write-Output "Latest Patch Installed: $($latestPatch.HotFixID) on $($latestPatch.InstalledOn)"
    }
}
catch {
    Write-Output "Error retrieving patch status: $($_.Exception.Message)"
}
