# Cleanup Inactive Entra & Autopilot Devices

Dit PowerShell-script is ontworpen om de digitale omgeving op te schonen door apparaten te verwijderen die al **90 dagen of langer** geen activiteit hebben vertoond. Het script houdt specifiek rekening met apparaten die geregistreerd zijn in **Windows Autopilot**, aangezien deze eerst daar verwijderd moeten worden voordat ze uit Entra ID kunnen worden gewist.

## 📝 Details
* **Auteur:** Alexander Zoutenbier
* **Datum:** 24 maart 2026
* **PowerShell Module:** `Microsoft.Graph`

---

## 🚀 Functionaliteit
Het script voert de volgende stappen uit:
1.  **Authenticatie:** Maakt verbinding met Microsoft Graph met de juiste scopes (`Device.ReadWrite.All` en `DeviceManagementServiceConfig.ReadWrite.All`).
2.  **Identificatie:** Zoekt naar alle devices waar de `ApproximateLastSignInDateTime` ouder is dan 90 dagen.
3.  **Autopilot Check:** Controleert voor elk inactief device of er een actieve koppeling is in de Windows Autopilot-service.
4.  **Verwijdering:** * Verwijdert eerst het object uit **Windows Autopilot** (indien aanwezig).
    * Verwijdert vervolgens het object uit **Entra ID**.

---

## 🛠️ Voorbereiding
Zorg ervoor dat de Microsoft Graph module is geïnstalleerd op het systeem:

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

### Vereiste Rechten
De gebruiker die het script uitvoert moet een van de volgende rollen hebben:
* Global Administrator
* Intune Administrator
* Cloud Device Administrator

---

## 📖 Gebruik
Het wordt sterk aangeraden om het script eerst te testen.

1.  **Testen (Simulatie):**
    Voeg `-WhatIf` toe aan de verwijder-commando's in het script om te zien welke apparaten gemarkeerd worden zonder ze daadwerkelijk te verwijderen.
    
2.  **Uitvoeren:**
    Open PowerShell als Administrator en start het script:
    ```powershell
    .\Invoke-EntraAutopilotCleanup.ps1
    ```

---

## ⚠️ Belangrijke Opmerkingen
* **Gereserveerde accounts:** Let op dat bepaalde 'kiosk' of 'room' devices soms langer dan 90 dagen offline kunnen zijn maar wel behouden moeten blijven. Filter deze eventueel uit op basis van een naamconventie.
* **Data vertraging:** De `ApproximateLastSignInDateTime` in Entra ID kan tot 14 dagen afwijken van de werkelijkheid. De marge van 90 dagen is gekozen om deze vertraging ruimschoots op te vangen.

---