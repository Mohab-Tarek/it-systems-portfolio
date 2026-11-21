"""Summarise failed Windows logons (Event ID 4625) from a CSV export.

Export the last 24 hours on the domain controller (PowerShell, run as admin):

    Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625; StartTime=(Get-Date).AddDays(-1)} |
      ForEach-Object { $x = [xml]$_.ToXml(); $d = $x.Event.EventData.Data
        [pscustomobject]@{ TimeCreated = $_.TimeCreated.ToString('s')
          TargetUserName = ($d | ? Name -eq 'TargetUserName').'#text'
          IpAddress = ($d | ? Name -eq 'IpAddress').'#text' } } |
      Export-Csv failed_logons.csv -NoTypeInformation

Usage: python failed_logins.py failed_logons.csv [threshold]
Exit code 1 when any account reaches the threshold, so a scheduled task can alert on it.
"""
import csv
import sys
from collections import Counter


def summarise(rows, threshold=5):
    by_user = Counter(r["TargetUserName"].lower() for r in rows)
    by_ip = Counter(r["IpAddress"] for r in rows)
    flagged = [(u, n) for u, n in by_user.most_common() if n >= threshold]
    return flagged, by_ip.most_common(5)


def main(path, threshold=5):
    with open(path, newline="", encoding="utf-8-sig") as f:
        rows = list(csv.DictReader(f))
    flagged, top_ips = summarise(rows, threshold)
    print(f"{len(rows)} failed logons in {path}\n")
    print(f"Accounts with {threshold} or more failures:")
    for user, n in flagged:
        print(f"  {user:<22}{n:>4}")
    print("\nTop source addresses:")
    for ip, n in top_ips:
        print(f"  {ip:<22}{n:>4}")
    return 1 if flagged else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1], int(sys.argv[2]) if len(sys.argv) > 2 else 5))
