##############################################
# SAUVEGARDE DU BUREAU UTILISATEUR VERS P:
##############################################

Clear-Host
Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host "   SAUVEGARDE DES TELECHARGEMENTS UTILISATEUR (C:\ -> P:\)   " -ForegroundColor Cyan
Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host ""

##############################################
# CHEMINS
##############################################

$UserName = $env:USERNAME
$Source   = "C:\Users\$UserName\Downloads"
$DestRoot = "P:\Copie_Telechargements_$UserName"
$Dest     = "$DestRoot\Downloads"

Write-Host "Utilisateur        : $UserName" -ForegroundColor DarkGray
Write-Host "Téléchargement source      : $Source"   -ForegroundColor DarkGray
Write-Host "Destination        : $Dest"     -ForegroundColor DarkGray
Write-Host ""

##############################################
# VERIFICATIONS
##############################################

if (-not (Test-Path $Source)) {
    Write-Host "ERREUR : Bureau introuvable." -ForegroundColor Red
    Read-Host "Appuyez sur ENTER pour quitter"
    exit
}

if (-not (Test-Path $Dest)) {
    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
    Write-Host "Dossier créé : $Dest" -ForegroundColor Green
}

##############################################
# COPIE
##############################################

Write-Host ""
Write-Host "Copie des fichiers de téléchargeents en cours..." -ForegroundColor Yellow

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
