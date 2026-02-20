$ErrorActionPreference = "Stop"

function Get-InstalledAdobeReader {
    $paths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    foreach ($path in $paths) {
        $app = Get-ItemProperty $path -ErrorAction SilentlyContinue |
            Where-Object {
                $_.DisplayName -match "Adobe\s+Acrobat\s+Reader" -or
                $_.DisplayName -match "Adobe\s+Reader"
            } |
            Select-Object -First 1

        if ($app) { return $app }
    }

    return $null
}

function Install-AdobeReader {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "winget n'est pas disponible sur ce poste."
    }

    Write-Host "Installation de la dernière version d'Adobe Acrobat Reader..." -ForegroundColor Cyan

    $args = @(
        "install",
        "--id", "Adobe.Acrobat.Reader.64-bit",
        "-e",
        "--silent",
        "--accept-package-agreements",
        "--accept-source-agreements"
    )

    $process = Start-Process -FilePath "winget" -ArgumentList $args -Wait -PassThru

    if ($process.ExitCode -ne 0) {
        throw "L'installation a échoué (code $($process.ExitCode))."
    }
}

try {

    Write-Host "Vérification d'Adobe Acrobat Reader..." -ForegroundColor Cyan
    $adobe = Get-InstalledAdobeReader

    if ($adobe) {
        Write-Host "----------------------------------------"
        Write-Host "Adobe est déjà installé :" -ForegroundColor Green
        Write-Host "Nom     : $($adobe.DisplayName)"
        Write-Host "Version : $($adobe.DisplayVersion)"
        Write-Host "----------------------------------------"
    }
    else {
        Write-Host "Adobe Acrobat Reader n'est PAS installé." -ForegroundColor Yellow
        $response = Read-Host "Voulez-vous l'installer maintenant ? (O/N)"

        if ($response -match "^(O|Oui|Y|Yes)$") {
            Install-AdobeReader

            # Vérification après installation
            $check = Get-InstalledAdobeReader
            if ($check) {
                Write-Host "----------------------------------------"
                Write-Host "Installation terminée avec succès." -ForegroundColor Green
                Write-Host "Version installée : $($check.DisplayVersion)"
                Write-Host "----------------------------------------"
            }
            else {
                Write-Host "Attention : installation terminée mais Adobe non détecté." -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "Installation annulée par l'utilisateur." -ForegroundColor DarkGray
        }
    }

    Write-Host ""
    Write-Host "Vérification terminée. Aucun problème détecté." -ForegroundColor Green
    Write-Host ""

    $close = Read-Host "Voulez-vous fermer cette fenêtre PowerShell ? (O/N)"

    if ($close -match "^(O|Oui|Y|Yes)$") {
        Write-Host "Fermeture en cours..." -ForegroundColor Cyan
        Start-Sleep -Seconds 2
        exit 0
    }
    else {
        Write-Host "La fenêtre reste ouverte. Appuyez sur Entrée pour quitter manuellement."
        Read-Host
    }

}
catch {
    Write-Host ""
    Write-Host "ERREUR : $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    $close = Read-Host "Une erreur est survenue. Voulez-vous fermer la fenêtre ? (O/N)"

    if ($close -match "^(O|Oui|Y|Yes)$") {
        exit 1
    }
}
