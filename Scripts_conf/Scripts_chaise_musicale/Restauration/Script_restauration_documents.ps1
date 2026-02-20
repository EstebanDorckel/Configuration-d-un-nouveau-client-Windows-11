##############################################
# RESTAURATION DES DOCUMENTS DEPUIS D:
##############################################

Clear-Host
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   RESTAURATION DES DOCUMENTS (D -> C)            " -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

##############################################
# CHEMINS
##############################################

$UserName = $env:USERNAME
$Source   = "D:\Copie_Documents_$UserName\Documents"
$DestRoot = "C:\Users\$UserName"
$Dest     = "$DestRoot\Documents"

Write-Host "Utilisateur              : $UserName" -ForegroundColor DarkGray
Write-Host "Documents SAUVEGARDE (source) : $Source"   -ForegroundColor DarkGray
Write-Host "Documents ACTUEL (destination): $Dest"     -ForegroundColor DarkGray
Write-Host ""

##############################################
# VERIFICATIONS
##############################################

# Vérifie que la sauvegarde existe
if (-not (Test-Path $Source)) {
    Write-Host "ERREUR : Sauvegarde des Documents introuvable sur D:." -ForegroundColor Red
    Read-Host "Appuyez sur ENTER pour quitter"
    exit
}

# Vérifie que le Documents actuel existe, sinon le crée
if (-not (Test-Path $Dest)) {
    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
    Write-Host "Dossier Documents créé : $Dest" -ForegroundColor Green
}

##############################################
# RESTAURATION (COPIE SANS FICHIERS SYSTEME)
##############################################

Write-Host ""
Write-Host "Restauration du contenu de l'ancien Documents vers le nouveau..." -ForegroundColor Yellow
Write-Host "(Les fichiers système comme Documents.ini sont exclus.)" -ForegroundColor DarkGray
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
Write-Host "   RESTAURATION DES DOCUMENTS TERMINÉE           " -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Appuyez sur ENTER pour fermer la fenêtre"
