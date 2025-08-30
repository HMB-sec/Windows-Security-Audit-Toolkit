[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
Write-Output "=== Local User Account Audit ==="

# Get local users
$users = Get-LocalUser

foreach ($user in $users) {
    $flags = @()

    # Disabled account
    if ($user.Enabled -eq $false) {
        $flags += "DISABLED"
    }

    # No password (you need admin rights for this)
    if ($user.PasswordRequired -eq $false) {
        $flags += "NO PASSWORD"
    }

    # Admin account check
    $isAdmin = (Get-LocalGroupMember -Group "Administrators" | Where-Object { $_.Name -eq $user.Name }) -ne $null
    if ($isAdmin) {
        $flags += "ADMIN"
    }

    # Never logged in or inactive > 90 days
    $lastLogon = $user.LastLogon
    if (!$lastLogon) {
        $flags += "NEVER LOGGED IN"
    } elseif ((New-TimeSpan -Start $lastLogon).Days -gt 90) {
        $flags += "INACTIVE >90 DAYS"
    }

    # Report user if any flags
    if ($flags.Count -gt 0) {
        Write-Output "WARNING: $($user.Name): $($flags -join ', ')"
    }
}
