# Set-ExplorerStartToThisPC.ps1
# Ouvre l'Explorateur sur "Ce PC" au lieu de "Accueil"

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$name    = "LaunchTo"
$value   = 1   # 1 = Ce PC | 2 = Accueil / Accès rapide

# Crée la clé si elle n'existe pas
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Applique la valeur
New-ItemProperty -Path $regPath -Name $name -PropertyType DWord -Value $value -Force | Out-Null

Write-Host "OK: Explorateur configuré pour s'ouvrir sur 'Ce PC' (LaunchTo=$value)." -ForegroundColor Green

# Redémarre l'Explorateur pour appliquer immédiatement
Get-Process explorer -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Process explorer.exe
