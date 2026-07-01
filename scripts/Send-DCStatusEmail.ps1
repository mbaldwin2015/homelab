<#
    .SYNOPSIS
    Sends a daily DC health status email via the internal Postfix relay.

    .DESCRIPTION
    Checks the status of AD-related services (NTDS, DNS, Netlogon) and reports the servers last boot time.

    Uses Send-MailMessage, which Microsoft has marked deprecated, however it is used here because this is an unauthenticated, internal-only relay with no modern auth requirement. (not something to carry into a real production environment)

    .NOTES
    Run via Task Scheduler, 
#>

# CONFIG
$SmtpServer = "10.0.40.10"
$SmtpPort   = 25
$From       = "dc01@lab.internal"
$To         = "ubuntu-srv01@lab.internal"
$Subject    = "DC Daily Status - $(Get-Date -Format 'MM-dd-yyyy')"

# SERVICE STATUS
$ServicesToCheck = @("NTDS", "DNS", "Netlogon")
$ServiceStatusLines = foreach ($svc in $ServicesToCheck) {
    $status = (Get-Service -Name $svc -ErrorAction SilentlyContinue).Status
    if (-not $status) {
        "  $svc = NOT FOUND"
    } else {
        "  $svc = $status"
    }
}

# LAST BOOT TIME
$LastBoot = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$LastBootFormatted = Get-Date $LastBoot -Format 'MM-dd-yyyy HH:mm:ss'

# EMAIL BODY
$Body = @"
DC Daily Status - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

Core services:
$($ServiceStatusLines -join "`n")

Last boot time: $LastBootFormatted
"@

# SEND EMAIL
Send-MailMessage -SmtpServer $SmtpServer -Port $SmtpPort -From $From -To $To -Subject $Subject -Body $Body