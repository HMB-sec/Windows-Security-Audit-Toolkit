# check_rdp_exposure.ps1

[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
Write-Output "=== RDP Exposure Scanner ==="

# Step 1: Check if RDP is enabled in the registry
$rdpRegPath = "HKLM:\System\CurrentControlSet\Control\Terminal Server"
$rdpStatus = Get-ItemProperty -Path $rdpRegPath -Name "fDenyTSConnections" -ErrorAction SilentlyContinue

if ($rdpStatus.fDenyTSConnections -eq 0) {
    Write-Output "RDP is ENABLED"
} else {
    Write-Output "RDP is DISABLED"
}

# Step 2: Check if port 3389 is listening
$rdpPortCheck = Get-NetTCPConnection -LocalPort 3389 -State Listen -ErrorAction SilentlyContinue
if ($rdpPortCheck) {
    Write-Output "RDP Port 3389 is LISTENING"
} else {
    Write-Output "RDP Port 3389 is NOT LISTENING"
}

# Step 3: Check Windows Firewall rule for RDP
$rdpFwRule = Get-NetFirewallRule -DisplayName "*Remote Desktop*" -ErrorAction SilentlyContinue | Where-Object {$_.Enabled -eq "True"}
if ($rdpFwRule) {
    Write-Output "Windows Firewall has RDP RULE ENABLED"
} else {
    Write-Output "Windows Firewall has NO ENABLED RULE for RDP"
}
