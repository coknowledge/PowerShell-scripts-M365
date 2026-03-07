# 🚀 Autopilot Turbo Register
**Versie:** 1.0  
**Auteur:** Alexander Zoutenbier

---

## 🛠️ Wat doet deze tool?
Deze tool automatiseert het ophalen en uploaden van de hardware hash van nieuwe Windows-laptops naar Microsoft Intune. Dankzij de "Turbo" methode hoef je geen handmatige CSV-bestanden meer te exporteren en te importeren; alles gaat direct online naar de tenant.

## 📥 1. Voorbereiding (Eenmalig op beheer-PC)
Zorg dat de USB-stick correct is klaargezet met het voorbereidingsscript. De stick moet de volgende structuur bevatten in de map `\Autopilot`:
* `Get-WindowsAutopilotInfo.ps1` (Microsoft script)
* `UploadToAutopilot.ps1` (Jouw maatwerk script)
* `START.bat` (De bypass-starter)

---

## 💻 2. Uitvoeren op de nieuwe laptop (OOBE)
Volg deze stappen exact voor een succesvolle registratie:

1.  **Internet:** Sluit een ethernetkabel aan of verbind met Wi-Fi (via de standaard Windows-instellingen).
2.  **Prompt:** Zodra je bij het scherm "Regio/Land" bent, druk op:  
    **`Shift + F10`** *(Laptops met een Fn-toets: `Shift + Fn + F10`)*
3.  **USB-Drive:** Typ de letter van je USB-stick (bijv. `D:`) en druk op **Enter**.
4.  **Navigeren:** Typ `cd Autopilot` en druk op **Enter**.
5.  **Turbo Start:** Typ simpelweg:  
    **`START`** *(Dit voert het batch-bestand uit dat alle beveiligingsblokkades omzeilt).*

---

## 🔐 3. Registratieproces
* Het scherm kleurt geel met de melding: `--- Autopilot Tooling by Alexander Zoutenbier ---`.
* Er verschijnt een inlogvenster. Gebruik je **Intune Administrator** gegevens om de upload te autoriseren.
* Wacht tot het script bevestigt dat de hash succesvol is geüpload.
* Herstart de laptop. Na de herstart zal de laptop de bedrijfsbranding tonen en is hij klaar voor de uitrol.

---

## ⚠️ Belangrijke aandachtspunten
* **Execution Policy:** Gebruik altijd het `START` commando (het .bat bestand). Dit dwingt een 'Bypass' af, zodat het PowerShell-script niet wordt geblokkeerd door de standaard beveiliging van Windows.
* **Wachtwoorden:** Zoals ingesteld, worden wachtwoorden na de herstart onthouden voor een naadloze ervaring.
* **Fouten:** Krijg je een foutmelding over internet? Controleer of je de laptop echt hebt verbonden voordat je het script start.

---
*Gemaakt met passie voor automatisering door Alexander Zoutenbier.*