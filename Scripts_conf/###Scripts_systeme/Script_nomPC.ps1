Write-Host "======================================================"                                                                     -ForegroundColor Cyan
Write-Host "========= CHANGEMENT DU NOM DE L'ORDINATEUR ==========" 																	-ForegroundColor Cyan
Write-Host "======================================================"                                                                     -ForegroundColor Cyan
Write-Host ""

# Vérifie si le script est exécuté en administrateur
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Ce script doit être exécuté en tant qu'Administrateur !"
    pause
    exit
}
# Nom actuel de l'ordinateur
$nomActuel = $env:COMPUTERNAME
Write-Host "Nom actuel de l'ordinateur : " -NoNewline
Write-Host $nomActuel 																													-ForegroundColor Yellow
# Demande du nouveau nom
do {
$nouveauNom = Read-Host "`nEntrez le nouveau nom (15 caractères max, lettres/chiffres/tirets uniquement)"
if ($nouveauNom -eq "") {
Write-Host "Le nom ne peut pas être vide !" 																							-ForegroundColor Red
                            }
elseif ($nouveauNom.Length -gt 15) {
Write-Host "Le nom doit faire 15 caractères maximum !" 																					-ForegroundColor Red
}
elseif ($nouveauNom -notmatch "^[a-zA-Z0-9\-]+$") {
Write-Host "Caractères autorisés : lettres, chiffres et tiret (-) uniquement." 															-ForegroundColor Red
                            }
} while ($nouveauNom -eq "" -or $nouveauNom.Length -gt 15 -or $nouveauNom -notmatch "^[a-zA-Z0-9\-]+$")
# Confirmation
Write-Host "`nVous allez renommer l'ordinateur :" 																						-ForegroundColor White
Write-Host " $nomActuel" 																												-ForegroundColor Gray
Write-Host "→ $nouveauNom" 																												-ForegroundColor Green
$confirm = Read-Host "`nConfirmez-vous ce changement ? (O/n)"
if ($confirm -notmatch "^[OoYy]?$") {
Write-Host "Opération annulée." 																										-ForegroundColor Yellow
pause
exit
}
# Application du nouveau nom
try {
Rename-Computer -NewName $nouveauNom -Force -Restart
Write-Host "`nL'ordinateur va redémarrer pour appliquer le nouveau nom : $nouveauNom" 													-ForegroundColor Green
}
catch {
Write-Host "Erreur lors du renommage : $_" -ForegroundColor Red
}
# Si on arrive ici, c’est que -Restart n’a pas été pris en compte
    # Si on arrive ici, c’est que le PC n’a pas redémarré
    Write-Host "`nRedémarrez l'ordinateur manuellement pour que le changement prenne effet." 											-ForegroundColor Yellow


$lastPS = Get-Process -Name "powershell" | Sort-Object StartTime -Descending | Select-Object -First 1

pause
exit