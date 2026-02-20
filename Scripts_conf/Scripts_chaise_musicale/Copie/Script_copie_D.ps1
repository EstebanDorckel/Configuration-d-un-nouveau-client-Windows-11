##############################################
# SAUVEGARDE DU DISQUE D: VERS P:
##############################################

Clear-Host
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   SAUVEGARDE DU DISQUE D: (D:\ -> P:\) " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

##############################################
# CHEMINS
##############################################

$Source = "D:\"
$Dest   = "P:\Copie_D_$UserName"

Write-Host "Source        : $Source" -ForegroundColor DarkGray
Write-Host "Destination   : $Dest"   -ForegroundColor DarkGray
Write-Host ""

##############################################
# VERIFICATIONS
##############################################

if (-not (Test-Path $Source)) {
    Write-Host "ERREUR : Le disque D: est introuvable." -ForegroundColor Red
    Read-Host "Appuyez sur ENTER pour quitter"
    exit
}

if (-not (Test-Path $Dest)) {
    Write-Host "ERREUR : Le disque P: est introuvable." -ForegroundColor Red
    Read-Host "Appuyez sur ENTER pour quitter"
    exit
}

##############################################
# COPIE
##############################################

Write-Host ""
Write-Host "Copie de tout le contenu du disque D: vers P: en cours..." -ForegroundColor Yellow

robocopy `
    "$Source" `
    "$Dest" `
    /E /COPY:DAT /R:1 /W:1 /NP

##############################################
# FIN
##############################################

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   SAUVEGARDE TERMINÉE                        " -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Appuyez sur ENTER pour fermer la fenêtre"
