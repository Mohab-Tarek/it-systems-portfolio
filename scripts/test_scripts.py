from datetime import datetime

from failed_logins import summarise
from stale_ad_accounts import stale


def test_failed_logins():
    rows = [{"TargetUserName": "Admin", "IpAddress": "10.20.1.15"}] * 6
    rows += [{"TargetUserName": "hr.assistant", "IpAddress": "10.20.1.42"}]
    flagged, ips = summarise(rows, threshold=5)
    assert flagged == [("admin", 6)]
    assert ips[0] == ("10.20.1.15", 6)


def test_stale():
    rows = [
        {"SamAccountName": "a.old", "LastLogonDate": "2026-01-01T09:00:00"},
        {"SamAccountName": "b.active", "LastLogonDate": "2026-11-01T09:00:00"},
        {"SamAccountName": "c.never", "LastLogonDate": ""},
    ]
    assert stale(rows, datetime(2026, 11, 21)) == [("a.old", "2026-01-01T09:00:00"), ("c.never", "never")]


if __name__ == "__main__":
    test_failed_logins()
    test_stale()
    print("all checks passed")
