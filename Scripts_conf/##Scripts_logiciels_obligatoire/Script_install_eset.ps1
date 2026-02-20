Clear-Host
Write-Host "===========================================" 							-ForegroundColor Cyan
Write-Host "=      INSTALLATION ESET WORKSTATION      =" 							-ForegroundColor Cyan
Write-Host "===========================================" 							-ForegroundColor Cyan
Write-Host ""

$SoftwareName = "ESET Workstation"
$Executable   = '\\DDLSVFILES.Eurofoil.Local\it\ESET\Workstation.exe'

Write-Host "Logiciel : " -NoNewline	
Write-Host $SoftwareName 															-ForegroundColor Yellow
Write-Host "Chemin   : $Executable`n"

$reponse = Read-Host "Voulez-vous lancer ESET maintenant ? (O/N)"

if ($reponse -match '^[OoYy]$') {

    Write-Host "`nVérification du fichier en cours..." 								-ForegroundColor Cyan

    if (Test-Path $Executable) {
        Write-Host "Fichier trouvé → Lancement en cours..." 						-ForegroundColor Green
        Start-Process -FilePath $Executable
        Write-Host "ESET lancé avec succès !" 										-ForegroundColor Green
    }
    else {
        Write-Host "ERREUR : Le fichier n'est pas accessible !" 					-ForegroundColor Red
        Write-Host "Chemin vérifié : $Executable" 									-ForegroundColor Gray
        Write-Host "Vérifie que :`n   • le partage réseau est accessible`n   • tu as les droits en lecture`n   • tu es connecté au VPN si nécessaire" -ForegroundColor Yellow
    }
}
else {
    Write-Host "Lancement annulé." 													-ForegroundColor Magenta
}

Write-Host ""
Pause
exit