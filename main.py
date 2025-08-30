import subprocess
from datetime import datetime
import os


def run_check(script_path):
    """Run a PowerShell check and return its output or error message."""
    abs_path = os.path.abspath(script_path)
    command = (
        'powershell -NoProfile -ExecutionPolicy Bypass '
        f'-Command "[Console]::OutputEncoding = '
        f'[System.Text.UTF8Encoding]::new(); & \'{abs_path}\'"'
    )

    result = subprocess.run(
        command,
        capture_output=True,
        shell=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )

    if result.stderr.strip():
        return f"[ERROR running {script_path}]\n{result.stderr.strip()}"

    return result.stdout


def main():
    """Main entry point for running all audit checks."""
    os.makedirs("results", exist_ok=True)
    report_file = "results/audit_report.txt"

    print("🔍 Running Windows Security Audit...")

    checks = [
        "modules/check_uac.ps1",
        "modules/check_defender.ps1",
        "modules/check_smb_shares.ps1",
        "modules/check_startup_tasks.ps1",
        "modules/check_services_ports.ps1",
        "modules/check_patch_status.ps1",
        "modules/check_unquoted_service_paths.ps1",
        "modules/check_local_users.ps1",
        "modules/check_rdp_exposure.ps1",
    ]

    report = (
        "=== Windows Security Audit Report ===\n"
        f"Generated: {datetime.now()}\n\n"
    )

    for check in checks:
        output = run_check(check)
        report += output.strip() + "\n\n"

    # Write report using UTF-8 (without BOM)
    with open(report_file, "w", encoding="utf-8") as f:
        f.write(report)

    print(f"✅ Audit complete. Report saved to {report_file}")


if __name__ == "__main__":
    main()
