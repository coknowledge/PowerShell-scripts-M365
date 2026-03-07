# 1. Voorbereiding op eigen PC
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
Clear-Host
$driveInput = Read-Host "Voer de schijfletter in (bijv. D of E)"
$usbDrive = "$($driveInput.ToUpper().Trim(':')):"
$usbPath = "$usbDrive\Autopilot"

if (-not (Test-Path $usbDrive)) { Write-Error "Schijf niet gevonden!"; return }

# 2. Map & Scripts downloaden
if (-not (Test-Path $usbPath)) { New-Item -ItemType Directory -Path $usbPath -Force | Out-Null }
Write-Host "Downloaden van Get-WindowsAutopilotInfo..." -ForegroundColor Cyan
Save-Script -Name Get-WindowsAutopilotInfo -Path $usbPath -Force

# 3. Het PowerShell script maken (UploadToAutopilot.ps1)
$psContent = @"
Write-Host "--- Autopilot Tooling by Alexander Zoutenbier ---" -ForegroundColor Yellow
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Intune)) {
    Install-Module -Name Microsoft.Graph.Intune -Force -AllowClobber -Scope CurrentUser
}
.\Get-WindowsAutopilotInfo.ps1 -Online
"@
$psContent | Out-File -FilePath (Join-Path $usbPath "UploadToAutopilot.ps1") -Encoding utf8

# 4. DE OPLOSSING: Het Batch-bestand maken (START.bat)
# Dit bestand dwingt de Bypass af bij het opstarten
$batContent = "@echo off`npowershell -ExecutionPolicy Bypass -File `"%~dp0UploadToAutopilot.ps1`"`npause"
$batContent | Out-File -FilePath (Join-Path $usbPath "START.bat") -Encoding ASCII

Write-Host "Klaar! Gebruik op de laptop na Shift+F10 simpelweg het commando: START" -ForegroundColor Green