# --- 1. Parameters (Altijd bovenaan) ---
param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("All", "Single")]
    [string]$Mode = "All",

    [Parameter(Mandatory=$false)]
    [string]$UserEmail
)

# --- 2. Modules laden ---
$Modules = @("Microsoft.Graph", "ExchangeOnlineManagement")
foreach ($ModuleName in $Modules) {
    if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
        Install-Module -Name $ModuleName -Force -AllowClobber -Scope CurrentUser -ErrorAction Stop
    }
}

# --- 3. Verbinding ---
# We gebruiken WAM login om je eerdere verzoek tot sessie-behoud te respecteren
Connect-MgGraph -Scopes "User.ReadWrite.All" -ContextScope CurrentUser -NoWelcome
if (-not (Get-PSSession | Where-Object { $_.ConfigurationName -eq "Microsoft.Exchange" })) {
    Connect-ExchangeOnline -ShowBanner:$false
}

# --- 4. Selectie ---
$targetUsers = if ($Mode -eq "Single") {
    Get-Mailbox -Identity $UserEmail | Select-Object UserPrincipalName, ExternalDirectoryObjectId
} else {
    Get-Mailbox -ResultSize Unlimited -RecipientTypeDetails UserMailbox | Select-Object UserPrincipalName, ExternalDirectoryObjectId
}

# --- 5. Uitvoering ---
foreach ($user in $targetUsers) {
    Write-Host "Verwerken: $($user.UserPrincipalName)" -ForegroundColor Cyan
    
    try {
        # STAP A: Regionale taal & Tijdzone
        Set-MailboxRegionalConfiguration -Identity $user.UserPrincipalName -Language "nl-NL" -TimeZone "W. Europe Standard Time" -DateFormat "d-M-yyyy" -TimeFormat "H:mm" -LocalizeDefaultFolderName -Confirm:$false

        # STAP B: Werkuren & Werkdagen (Dit lost de melding in je screenshot op)
        Set-MailboxCalendarConfiguration -Identity $user.UserPrincipalName `
            -WorkingHoursStartTime "08:30:00" `
            -WorkingHoursEndTime "17:00:00" `
            -WorkingHoursTimeZone "W. Europe Standard Time" `
            -WeekStartDay "Monday" `
            -ErrorAction Stop

        # STAP C: Microsoft Graph Preferred Language
        if ($user.ExternalDirectoryObjectId) {
            Update-MgUser -UserId $user.ExternalDirectoryObjectId -PreferredLanguage "nl-NL"
        }

        Write-Host "  [OK] Alles bijgewerkt." -ForegroundColor Green
    }
    catch {
        Write-Warning "  [FOUT]: $($_.Exception.Message)"
    }
}