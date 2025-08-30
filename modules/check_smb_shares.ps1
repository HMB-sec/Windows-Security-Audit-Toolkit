Write-Output "=== SMB Share Exposure Check ==="

try {
    # Get list of SMB shares excluding default system shares
    $shares = Get-SmbShare | Where-Object { $_.Name -notin @("IPC$", "ADMIN$", "C$") }

    if (-not $shares -or $shares.Count -eq 0) {
        Write-Output "No user-created SMB shares found. PASS"
    } else {
        foreach ($share in $shares) {
            try {
                $access = Get-SmbShareAccess -Name $share.Name
                $isExposed = $false

                foreach ($entry in $access) {
                    if ($entry.AccountName -eq "Everyone" -and $entry.AccessControlType -eq "Allow") {
                        Write-Output "WARNING: Share '$($share.Name)' is accessible to Everyone"
                        $isExposed = $true
                    }
                }

                if (-not $isExposed) {
                    Write-Output "Share '$($share.Name)' permissions appear safe"
                }
            } catch {
                Write-Output "ERROR: Could not retrieve access rules for share '$($share.Name)'"
            }
        }
    }
} catch {
    Write-Output "ERROR: Failed to enumerate SMB shares."
}
