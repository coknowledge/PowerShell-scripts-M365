# M365 Regional & Calendar Fixer

Dit script automatiseert het instellen van de juiste taal, tijdzone en werkuren voor Microsoft 365 gebruikers. Het lost specifiek het probleem op waarbij Outlook aangeeft dat iemand in een afwijkende tijdzone werkt (bijv. "9 uur vroeger").

## 📋 Wat doet dit script?

1. **Modules**: Controleert en installeert benodigde PowerShell modules (`Microsoft.Graph` en `ExchangeOnlineManagement`).
2. **Connectie**: Maakt verbinding met M365 via een moderne login die je sessie onthoudt.
3. **Regionale Instellingen**: Zet de mailbox op Nederlands (`nl-NL`) en de tijdzone op `W. Europe Standard Time`.
4. **Agenda-correctie**: Stelt de werkuren in op **08:30 - 17:00** en de werkweek start op maandag.
5. **Graph Update**: Werkt de `PreferredLanguage` van het Azure/Entra ID profiel bij.

## 🚀 Gebruik

### Voor alle gebruikers:

Open PowerShell als Administrator en voer het script uit zonder parameters:

```powershell
.\NaamVanScript.ps1 -Mode All

```

### Voor één specifieke gebruiker:

Gebruik de `Single` mode en geef het e-mailadres op:

```powershell
.\NaamVanScript.ps1 -Mode Single -UserEmail "collega@domein.nl"

```

## 🛠️ Vereisten

* **Rechten**: Je moet Global Admin of Exchange Admin zijn.
* **Sessie**: Het script maakt gebruik van de `ContextScope CurrentUser`. Dit zorgt ervoor dat je na een herstart van je computer niet direct opnieuw hoeft in te loggen, mits de browser-token nog geldig is.
