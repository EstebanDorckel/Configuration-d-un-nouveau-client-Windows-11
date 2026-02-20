#Requires -RunAsAdministrator

# Configuration silencieuse FortiClient VPN - Connexion "Eurofoil" - Sans raccourci
# Port personnalisé 10443 - Aucun certificat client

$ErrorActionPreference = "Stop"

$FortiClientPath = "C:\Program Files\Fortinet\FortiClient\FortiClient.exe"
$ConfigFile      = "$env:APPDATA\Fortinet\FortiClient\conf\conf.xml"

# Vérifie que FortiClient est bien installé
if (-not (Test-Path $FortiClientPath)) {
    Write-Error "FortiClient non détecté à l'emplacement attendu : $FortiClientPath"
    exit 1
}

# Remplace ici ton vrai nom de domaine FortiGate
$RemoteGateway = "https://fortigate.eurofoil.com:10443"   # ← À MODIFIER

# Crée le dossier de configuration si inexistant
$ConfigDir = Split-Path $ConfigFile -Parent
if (-not (Test-Path $ConfigDir)) {
    New-Item -Path $ConfigDir -ItemType Directory -Force | Out-Null
}

# Configuration XML exacte (testée sur FortiClient 7.2 / 7.4)
$VpnConfigXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<forticlient_configuration>
    <vpn>
        <options>
            <promptcertificate>0</promptcertificate>
            <keep_running>1</keep_running>
        </options>
        <sslvpn>
            <connections>
                <connection>
                    <name>Eurofoil</name>
                    <description></description>
                    <server>$RemoteGateway</server>
                    <port>10443</port>
                    <custom_port>1</custom_port>
                    <sso_enabled>0</sso_enabled>
                    <certificate></certificate>
                    <promptcertificate>0</promptcertificate>
                    <auth_type>0</auth_type>
                </connection>
            </connections>
        </sslvpn>
    </vpn>
</forticlient_configuration>
"@

# Écrit la configuration
Write-Host "Configuration de la connexion VPN 'Eurofoil' en cours..." -ForegroundColor Cyan
$VpnConfigXml | Out-File -FilePath $ConfigFile -Encoding UTF8 -Force

# Redémarre proprement FortiClient pour prise en compte immédiate
Write-Host "Redémarrage de FortiClient..." -ForegroundColor Yellow
Get-Process | Where-Object { $_.ProcessName -like "Forti*" } | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3
Start-Process -FilePath $FortiClientPath -WindowStyle Minimized

Write-Host "`nConfiguration appliquée avec succès !" -ForegroundColor Green
Write-Host "   • Connexion : Eurofoil" 
Write-Host "   • Serveur   : $RemoteGateway"
Write-Host "   • Port      : 10443 (personnalisé)"
Write-Host "   • Certificat client : Aucun"
Write-Host "`nOuvre FortiClient → Onglet VPN → La connexion 'Eurofoil' est prête à l'emploi." -ForegroundColor Cyan