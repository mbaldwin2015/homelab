<#
.SYNOPSIS
    Creates AD users from a CSV, placing them in department OUs and adding them to department groups.
.DESCRIPTION
    Reads new-users.csv and provisions each user in lab.internal. OU path and group
    membership are derived from the Department column.
.NOTES
    Author: Michael Baldwin
    Lab: homelab Phase 5
#>

$Users = Import-Csv -Path "C:\Scripts\new-users.csv"
$Domain = "DC=lab,DC=internal"

foreach ($User in $Users) {

    $OUPath    = "OU=$($User.Department),OU=Staff,$Domain"
    $GroupName = "GG-$($User.Department)"
    $UPN       = "$($User.SamAccountName)@lab.internal"
    $Password  = ConvertTo-SecureString "TempP@ssw0rd2026!" -AsPlainText -Force

    New-ADUser `
        -Name              "$($User.FirstName) $($User.LastName)" `
        -GivenName         $User.FirstName `
        -Surname           $User.LastName `
        -SamAccountName    $User.SamAccountName `
        -UserPrincipalName $UPN `
        -Department        $User.Department `
        -Title             $User.Title `
        -Path              $OUPath `
        -AccountPassword   $Password `
        -ChangePasswordAtLogon $true `
        -Enabled           $true

    Add-ADGroupMember -Identity $GroupName -Members $User.SamAccountName

    Write-Host "Created $($User.SamAccountName) in $($User.Department)"
}