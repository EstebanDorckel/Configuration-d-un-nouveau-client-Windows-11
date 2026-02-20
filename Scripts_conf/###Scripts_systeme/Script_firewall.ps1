# Désactivation du pare-feu Windows avec confirmation
Clear-Host
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "=   DÉSACTIVATION DU PARE-FEU WINDOWS DEFENDER    =" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# Vérifie si le script est déjà exécuté en administrateur
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Warning "Redémarrage du script en mode administrateur..."
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File", $MyInvocation.MyCommand.Path
    exit
}

Write-Host "Le pare-feu va être désactivé sur TOUS les profils :" -ForegroundColor Yellow
Write-Host "   • Domaine"
Write-Host "   • Privé"
Write-Host "   • Public"
Write-Host ""

$confirmation = Read-Host "Êtes-vous sûr de vouloir continuer ? (O/N)"

if ($confirmation -match "^[OoYy]$") {
    Write-Host "Désactivation en cours..." -ForegroundColor Yellow
    
    netsh advfirewall set allprofiles state off
    
    Write-Host ""
    Write-Host "PARE-FEU DÉSACTIVÉ avec succès sur tous les profils." -ForegroundColor Green
} else {
    Write-Host "Opération annulée par l'utilisateur." -ForegroundColor Red
}

Write-Host ""
Write-Host "Appuyez sur une touche pour quitter..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

pause
exit