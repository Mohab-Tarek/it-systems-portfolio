<#
Rebuilds the Active Directory layout and Group Policy baseline I ran at work, on a lab
domain controller, so console screenshots (ADUC, GPMC) come from a real, working setup.

Run as Domain Admin on a Windows Server lab VM already promoted with Install-ADDSForest.
Safe to run twice: existing OUs, groups, users and GPOs are left alone.

    .\build-ad-lab.ps1 -Company "Lab"
#>
#Requires -Modules ActiveDirectory, GroupPolicy
param(
    [string]$Company = "Lab",
    [string]$UsersCsv = "$PSScriptRoot\lab_users.csv",
    [SecureString]$InitialPassword = (Read-Host "Initial password for lab users" -AsSecureString)
)
$ErrorActionPreference = "Stop"
$domain = Get-ADDomain
$root = "OU=$Company,$($domain.DistinguishedName)"
$departments = "IT", "HR", "Finance", "Credit", "Collections", "Customer Service", "Sales"

function Confirm-OU($Name, $Path) {
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$Name'" -SearchBase $Path -SearchScope OneLevel)) {
        New-ADOrganizationalUnit -Name $Name -Path $Path -ProtectedFromAccidentalDeletion $true
    }
    "OU=$Name,$Path"
}

# OU tree: Company > Users (one OU per department), Computers, Groups, Service Accounts
$null = Confirm-OU $Company $domain.DistinguishedName
$usersOU = Confirm-OU "Users" $root
$computersOU = Confirm-OU "Computers" $root
$groupsOU = Confirm-OU "Groups" $root
$null = Confirm-OU "Service Accounts" $root

foreach ($d in $departments) {
    $null = Confirm-OU $d $usersOU
    $group = "GG-" + ($d -replace " ", "")
    if (-not (Get-ADGroup -Filter "Name -eq '$group'")) {
        New-ADGroup -Name $group -GroupScope Global -GroupCategory Security -Path $groupsOU -Description "$d staff"
    }
}

# Users: department OU, group membership, password change at first logon
foreach ($u in Import-Csv $UsersCsv) {
    $sam = ("{0}.{1}" -f $u.First, $u.Last).ToLower()
    if (Get-ADUser -Filter "SamAccountName -eq '$sam'") { continue }
    New-ADUser -Name "$($u.First) $($u.Last)" -GivenName $u.First -Surname $u.Last -SamAccountName $sam `
        -UserPrincipalName "$sam@$($domain.DNSRoot)" -Title $u.Title -Department $u.Department `
        -Path "OU=$($u.Department),$usersOU" -AccountPassword $InitialPassword -ChangePasswordAtLogon $true -Enabled $true
    Add-ADGroupMember -Identity ("GG-" + ($u.Department -replace " ", "")) -Members $sam
}

# Domain password and lockout policy
Set-ADDefaultDomainPasswordPolicy -Identity $domain.DNSRoot -MinPasswordLength 12 -ComplexityEnabled $true `
    -LockoutThreshold 5 -LockoutDuration "00:15:00" -LockoutObservationWindow "00:15:00" -MaxPasswordAge "90.00:00:00"

function Confirm-GPO($Name, $Target) {
    $gpo = Get-GPO -Name $Name -ErrorAction SilentlyContinue
    if (-not $gpo) { $gpo = New-GPO -Name $Name; $null = New-GPLink -Name $Name -Target $Target }
    $gpo
}

# Screen lock after 10 minutes for every user
$null = Confirm-GPO "BL - Screen lock 10 min" $usersOU
$key = "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop"
Set-GPRegistryValue -Name "BL - Screen lock 10 min" -Key $key -ValueName ScreenSaveActive -Type String -Value "1"
Set-GPRegistryValue -Name "BL - Screen lock 10 min" -Key $key -ValueName ScreenSaverIsSecure -Type String -Value "1"
Set-GPRegistryValue -Name "BL - Screen lock 10 min" -Key $key -ValueName ScreenSaveTimeOut -Type String -Value "600"

# Workstation hardening: no LLMNR, no removable storage
$null = Confirm-GPO "BL - Workstation hardening" $computersOU
Set-GPRegistryValue -Name "BL - Workstation hardening" -Key "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" `
    -ValueName EnableMulticast -Type DWord -Value 0
Set-GPRegistryValue -Name "BL - Workstation hardening" -Key "HKLM\Software\Policies\Microsoft\Windows\RemovableStorageDevices" `
    -ValueName Deny_All -Type DWord -Value 1

Write-Host "Done. Open dsa.msc and gpmc.msc to review, then join a client VM to the domain and run gpupdate /force."
