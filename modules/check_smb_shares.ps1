Write-Output "=== SMB Share Exposure Check ==="

# Get list of shares
$shares = Get-SmbShare | Where-Object { $_.Name -ne "IPC$" -and $_.Name -ne "ADMIN$" -and $_.Name -ne "C$" }

if ($shares.Count -eq 0) {
    Write-Output "No user-created SMB shares found. PASS"
} else {
    foreach ($share in $shares) {
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
    }
}
