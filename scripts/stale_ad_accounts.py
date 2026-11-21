"""List enabled Active Directory accounts with no logon in the last N days.

Export on the domain controller (PowerShell, RSAT ActiveDirectory module):

    Get-ADUser -Filter 'Enabled -eq $true' -Properties LastLogonDate |
      Select-Object SamAccountName, Name,
        @{n='LastLogonDate'; e={ if ($_.LastLogonDate) { $_.LastLogonDate.ToString('s') } }} |
      Export-Csv ad_users.csv -NoTypeInformation

Usage: python stale_ad_accounts.py ad_users.csv [days]
Review the list with HR before disabling anything: leavers are disabled, long leave is noted.
"""
import csv
import sys
from datetime import datetime, timedelta


def stale(rows, today, days=90):
    cutoff = today - timedelta(days=days)
    out = []
    for r in rows:
        last = r["LastLogonDate"].strip()
        if not last or datetime.fromisoformat(last) < cutoff:
            out.append((r["SamAccountName"], last or "never"))
    return out


def main(path, days=90):
    with open(path, newline="", encoding="utf-8-sig") as f:
        rows = list(csv.DictReader(f))
    found = stale(rows, datetime.now(), days)
    print(f"{len(found)} of {len(rows)} enabled accounts idle for {days}+ days:\n")
    for sam, last in found:
        print(f"  {sam:<22}last logon {last}")
    return 1 if found else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1], int(sys.argv[2]) if len(sys.argv) > 2 else 90))
