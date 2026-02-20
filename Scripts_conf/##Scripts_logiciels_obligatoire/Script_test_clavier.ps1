do {
Clear-Host
Write-Host "================================" -ForegroundColor Cyan
Write-Host "=     CLAVIER FRANCO-BELGE     =" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

$DesiredLayout      = "0000080c"            # Français (Belgique)
$DesiredInputMethod = "080c:0000080c"

# Récupère la disposition par défaut dans le registre
$CurrentLayout = Get-ItemPropertyValue -Path "HKCU:\Keyboard Layout\Preload" -Name "1" -ErrorAction SilentlyContinue

# Récupère la langue/disposition active via l'API Windows moderne
$ActiveLayout = (Get-WinUserLanguageList)[0].InputMethodTips[0]

if ($CurrentLayout -eq $DesiredLayout -or $ActiveLayout -like "*080C*") {
    Write-Host "La disposition du clavier est déjà en Français (Belgique)." -ForegroundColor Green
}
else {
    Write-Host "Disposition actuelle détectée : $CurrentLayout (actif : $ActiveLayout)" -ForegroundColor Yellow
    Write-Host "Configuration en Français (Belgique) en cours..." -ForegroundColor Cyan

    # 1. Force la disposition par défaut dans le registre
    Set-ItemProperty -Path "HKCU:\Keyboard Layout\Preload" -Name "1" -Value $DesiredLayout -Type String -Force

    # 2. Ajoute fr-BE si elle n'existe pas encore et force l'input method
    $LangList = Get-WinUserLanguageList
    if ($LangList.LanguageTag -notcontains "fr-BE") {
        $LangList = $LangList + (New-WinUserLanguageList "fr-BE")
    }
    # Met fr-BE en première position et force le clavier belge
    $LangList | Where-Object {$_.LanguageTag -eq "fr-BE"} | ForEach-Object {
        $_.InputMethodTips = @("080c:0000080c")
    }
    Set-WinUserLanguageList $LangList -Force

    Write-Host "Disposition clavier configurée avec succès sur Français (Belgique) !" -ForegroundColor Green
    Write-Host "Un redémarrage ou une déconnexion/reconnexion peut être nécessaire." -ForegroundColor Gray
}
} while ($false)

Pause
exit
