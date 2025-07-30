# Windows Security Audit Toolkit

A modular and extensible Python-powered auditing toolkit designed to check for misconfigurations and vulnerabilities on Windows systems. The toolkit uses PowerShell scripts to automate the scanning of common attack surfaces across 9 critical security areas.

---

## Features

- Modular architecture with 9 individual PowerShell scripts
- Easy-to-use Python wrapper to run all audits
- Output stored in a single report file for convenience
- Built for sysadmins, InfoSec students, blue teamers, and penetration testers

---

## Modules Overview

| # |          Module Name           |                       Description                      |
|---|--------------------------------|--------------------------------------------------------|
| 1 | *UAC & Privilege Escalation*   | Detects insecure UAC settings that may allow elevation |
| 2 | *Defender & AV Status*         | Checks Windows Defender/AV status and signatures       |
| 3 | *SMB Share Exposure*           | Identifies open/public SMB shares                      |
| 4 | *Startup & Persistence*        | Lists autorun entries and persistence mechanisms       |
| 5 | *Services & Open Ports*        | Lists running services and listening ports             |
| 6 | *Patch & Update Status*        | Checks for missing Windows patches and updates         |
| 7 | *Unquoted Service Paths*       | Finds unquoted service path vulnerabilities            |
| 8 | *Local User Accounts Audit*    | Audits local accounts and privileges                   |
| 9 | *RDP Exposure Scanner*         | Checks if RDP is enabled and exposed                   |

---

## Folder Structure

