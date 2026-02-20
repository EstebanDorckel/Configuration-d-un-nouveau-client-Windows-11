param(
    [Parameter(Mandatory=$true)]
    [string]$SoftwareName
)

Clear-Host
Write-Host "Recherche de la version de : $SoftwareName" -ForegroundColor Cyan
Write-Host "------------------------------------------------" -ForegroundColor DarkCyan

$Found = $false

# 1. Recherche dans le registre 64 bits (installations classiques)
$RegPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

foreach ($Path in $RegPaths) {
    Get-ItemProperty $Path |
        Where-Object { $_.DisplayName -like "*$SoftwareName*" } |
        Select-Object DisplayName, DisplayVersion, Publisher |
        ForEach-Object {
            Write-Host "INSTALLED (Registre) → $($_.DisplayName)  |  Version : $($_.DisplayVersion)" -ForegroundColor Green
            $Found = $true
        }
}

# 2. Recherche via Get-Package (winget, Chocolatey, Microsoft Store, etc.)
Get-Package -Name "*$SoftwareName*" -ErrorAction SilentlyContinue |
    Select-Object Name, Version, Source |
    ForEach-Object {
        $src = if($_.Source) { "($($_.Source))" } else { "" }
        Write-Host "INSTALLED (Get-Package) → $($_.Name)  |  Version : $($_.Version) $src" -ForegroundColor Yellow
        $Found = $true
    }

# 3. Si rien trouvé
if (-not $Found) {
    Write-Host "Aucun logiciel trouvé contenant '$SoftwareName'" -ForegroundColor Red
    Write-Host "Essaie avec une partie du nom (ex: Fire au lieu de Firefox)" -ForegroundColor Gray
}

Write-Host "`nFin." -ForegroundColor DarkGray

Write-Host "`nVérification de l'antivirus actif..." -ForegroundColor Cyan

$AntivirusDetected = $false

# 1. ESET (le plus courant chez vous)
if (Get-Service "ekrn" -ErrorAction SilentlyContinue) {
    $status = (Get-Service "ekrn").Status
    Write-Host "ESET détecté → Service ekrn : $status" -ForegroundColor Green
    $AntivirusDetected = $true
}

# 2. Windows Defender (si pas d'autre AV tiers)
elseif (Get-Service "WdNisSvc" -ErrorAction SilentlyContinue) {
    $status = (Get-Service "WdNisSvc").Status
    if ($status -eq "Running") {
        Write-Host "Windows Defender actif" -ForegroundColor Green
        $AntivirusDetected = $true
    }
}

# 3. Autres antivirus courants (au cas où)
$CommonAVServices = @(
    "McAfee", "Sophos", "TrendMicro", "Kaspersky", "Bitdefender", "Avast", "AVG", "Norton"
)
foreach ($av in $CommonAVServices) {
    if (Get-Service "*$av*" -ErrorAction SilentlyContinue | Where-Object {$_.Status -eq "Running"}) {
        Write-Host "$av détecté et actif" -ForegroundColor Green
        $AntivirusDetected = $true
    }
}

# Résultat final
if (-not $AntivirusDetected) {
    Write-Host "ATTENTION : Aucun antivirus actif détecté !" -ForegroundColor Red
}
else {
    Write-Host "Antivirus actif : OK" -ForegroundColor Green
}

Pause
exit