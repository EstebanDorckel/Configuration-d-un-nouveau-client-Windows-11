##############################################
# RESTAURATION DES IAMGES  DEPUIS D:
##############################################

Clear-Host
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   RESTAURATION DES IMAGES (D -> C)            " -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

##############################################
# CHEMINS
##############################################

$UserName = $env:USERNAME
$Source   = "D:\Copie_Pictures_$UserName\Pictures"
$DestRoot = "C:\Users\$UserName"
$Dest     = "$DestRoot\Pictures"

Write-Host "Utilisateur              : $UserName" -ForegroundColor DarkGray
Write-Host "Images SAUVEGARDE (source) : $Source"   -ForegroundColor DarkGray
Write-Host "Images ACTUEL (destination): $Dest"     -ForegroundColor DarkGray
Write-Host ""

##############################################
# VERIFICATIONS
##############################################

# Vérifie que la sauvegarde existe
if (-not (Test-Path $Source)) {
    Write-Host "ERREUR : Sauvegarde des images introuvable sur D:." -ForegroundColor Red
    Read-Host "Appuyez sur ENTER pour quitter"
    exit
}

# Vérifie que le images actuel existe, sinon le crée
if (-not (Test-Path $Dest)) {
    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
    Write-Host "Dossier Images créé : $Dest" -ForegroundColor Green
}

##############################################
# RESTAURATION (COPIE SANS FICHIERS SYSTEME)
##############################################

Write-Host ""
Write-Host "Restauration du contenu de l'ancien Images vers le nouveau..." -ForegroundColor Yellow
Write-Host "(Les fichiers système comme Pictures.ini sont exclus.)" -ForegroundColor DarkGray
Write-Host ""

robocopy `
    "$Source" `
    "$Dest" `
    /E /COPY:DAT /R:1 /W:1 /NP `
    /XF desktop.ini

##############################################
# FIN
##############################################

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   RESTAURATION DES IMAGES TERMINÉE           " -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Appuyez sur ENTER pour fermer la fenêtre"
