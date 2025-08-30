# Pester smoke tests for all audit toolkit modules

Describe "Audit Toolkit Modules Load Test" {

    $modules = @(
        "check_defender.ps1",
        "check_local_users.ps1",
        "check_patch_status.ps1",
        "check_rdp_exposure.ps1",
        "check_services_ports.ps1",
        "check_smb_shares.ps1",
        "check_startup_tasks.ps1",
        "check_uac.ps1",
        "check_unquoted_service_paths.ps1"
    )

    foreach ($module in $modules) {
        It "Should load $module without errors" {
            { . "$PSScriptRoot/../$module" } | Should -Not -Throw
        }
    }

    It "Sanity check always passes" {
        $true | Should -Be $true
    }
}
