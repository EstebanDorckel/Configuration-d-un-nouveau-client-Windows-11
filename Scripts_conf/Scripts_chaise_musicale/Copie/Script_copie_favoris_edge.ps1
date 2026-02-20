##############################################
# SAUVEGARDE DES FAVORIS DE EDGE VERS P:
##############################################

Clear-Host
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   SAUVEGARDE DES FAVORIS DE EDGE (C:\ -> P:\) " -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

##############################################
# CHEMINS
##############################################

$UserName = $env:USERNAME
$Source = "C:\Users\$UserName\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks"
$DestDir = "P:\Copie_Favoris_Edge_$UserName"
$Dest = Join-Path $DestDir "Bookmarks"

Write-Host "Source        : $Source" -ForegroundColor DarkGray
Write-Host "Destination   : $DestDir"   -ForegroundColor DarkGray
Write-Host ""

##############################################
# VERIFICATIONS
##############################################

if (-not (Test-Path $Source)) {
    Write-Host "ERREUR : Le fichier 'Bookmarks' est introuvable." -ForegroundColor Red
    Read-Host "Appuyez sur ENTER pour quitter"
    exit
}

if (-not (Test-Path $DestDir)) {
    Write-Host "Le dossier de destination n'existe pas, création..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $DestDir | Out-Null
}

##############################################
# COPIE
##############################################

Write-Host ""
Write-Host "Copie du fichier Bookmarks vers D: en cours..." -ForegroundColor Yellow

Copy-Item -Path $Source -Destination $Dest -Force

##############################################
# FIN
##############################################

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   SAUVEGARDE TERMINÉE                        " -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Appuyez sur ENTER pour fermer la fenêtre"
