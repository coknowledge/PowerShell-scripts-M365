<#
.SYNOPSIS
    Verwijdert inactieve devices (>90 dagen) uit Entra ID en Windows Autopilot.
    
.DESCRIPTION
    Script ontwikkeld door Alexander Zoutenbier
    Controleert op ApproximateLastSignInDateTime en verwijdert eerst het Autopilot object
    voordat het Entra ID object wordt opgeschoond.

.DATE
    2026-03-24
#>

# 1. Verbinding maken met de benodigde permissies
Connect-MgGraph -Scopes "Device.ReadWrite.All", "DeviceManagementServiceConfig.ReadWrite.All"

# 2. Definieer de grens (90 dagen geleden)
$CutoffDate = (Get-Date).AddDays(-90)

# 3. Haal alle devices op met hun activiteitsdatum
$AllDevices = Get-MgDevice -All -Property "Id", "DisplayName", "ApproximateLastSignInDateTime", "DeviceId"

# 4. Filter de inactieve devices
$StaleDevices = $AllDevices | Where-Object { 
    $_.ApproximateLastSignInDateTime -ne $null -and $_.ApproximateLastSignInDateTime -lt $CutoffDate 
}

Write-Host "Totaal aantal inactieve devices gevonden: $($StaleDevices.Count)" -ForegroundColor Cyan

foreach ($Device in $StaleDevices) {
    Write-Host "Verwerken van device: $($Device.DisplayName) (ID: $($Device.DeviceId))" -ForegroundColor Yellow
    
    # 5. Controleer of het device in Autopilot staat (via de DeviceId/Serial)
    # We zoeken in de Autopilot identities naar een match
    $AutopilotDevice = Get-MgDeviceManagementWindowsAutopilotDeviceIdentity -Filter "azureActiveDirectoryDeviceId eq '$($Device.Id)'"

    if ($AutopilotDevice) {
        Write-Host "  -> Device is geregistreerd in Autopilot. Verwijderen uit Autopilot..." -ForegroundColor DarkYellow
        # Verwijder uit Autopilot
        Remove-MgDeviceManagementWindowsAutopilotDeviceIdentity -WindowsAutopilotDeviceIdentityId $AutopilotDevice.Id -Confirm:$false
        
        # Soms duurt het even voordat de blokkade in Entra is opgeheven
        Start-Sleep -Seconds 2
    }

    # 6. Verwijder het device uit Entra ID
    try {
        Remove-MgDevice -DeviceId $Device.Id -Confirm:$false
        Write-Host "  [OK] Device succesvol verwijderd uit Entra ID." -ForegroundColor Green
    } catch {
        Write-Host "  [FOUT] Kon device niet verwijderen: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 7. Verbinding verbreken
Disconnect-MgGraph