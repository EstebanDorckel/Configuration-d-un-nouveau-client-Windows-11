# Désactivation d'IPv6 sur toutes les interfaces réseau
Clear-Host
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "=        DÉSACTIVATION COMPLÈTE DE L'IPV6         =" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

# Vérifie les droits administrateur
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Warning "Redémarrage du script en mode administrateur..."
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File", $MyInvocation.MyCommand.Path
    exit
}

Write-Host "Ce script va désactiver IPv6 sur TOUTES les cartes réseau actives et désactivées :" -ForegroundColor Yellow
Get-NetAdapter | Select-Object Name, InterfaceDescription, Status | Format-Table -AutoSize
Write-Host ""

$reponse = Read-Host "Êtes-vous sûr de vouloir désactiver IPv6 sur tous les profiles ? (O/N)"

if ($reponse -match "^[OoYy]$") {
    Write-Host "Désactivation d'IPv6 en cours..." -ForegroundColor Yellow

    # Désactive IPv6 sur toutes les interfaces (y compris celles désactivées)
    Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6 -ErrorAction SilentlyContinue

    # Message de confirmation
    Write-Host ""
    Write-Host "IPv6 a été désactivé avec succès sur toutes les cartes réseau." -ForegroundColor Green
    Write-Host "Un redémarrage peut être nécessaire pour que certains changements prennent pleinement effet." -ForegroundColor DarkGray
}
else {
    Write-Host "Opération annulée par l'utilisateur." -ForegroundColor Red
}

Write-Host ""
Write-Host "Appuyez sur une touche pour quitter..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

pause
exit