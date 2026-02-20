param(
    [string[]]$OfficeVersions = @("16.0"),
    [ValidateSet(0,1,3,6,12,24,36)]
    [int]$MonthsToKeepOffline = 12,
    [switch]$ForceCloseOutlook
)

#corrige les accents
try { [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false) } catch {}

function Ensure-RegistryKey {
    param([Parameter(Mandatory)][string]$Path)

    if (Test-Path $Path) { return $true }

    try {
        New-Item -Path $Path -Force -ErrorAction Stop | Out-Null
        return $true
    } catch [System.UnauthorizedAccessException] {
        return $false
    } catch {
        return $false
    }
}

function Try-SetRegDword {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][int]$Value
    )

    if (-not (Ensure-RegistryKey -Path $Path)) {
        return $false
    }

    try {
        New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType DWord -Force -ErrorAction Stop | Out-Null
        return $true
    } catch [System.UnauthorizedAccessException] {
        return $false
    } catch {
        return $false
    }
}

#Outlook ouvert ?
if (Get-Process outlook -ErrorAction SilentlyContinue) {
    if ($ForceCloseOutlook) {
        Write-Host "Outlook est ouvert -> fermeture..." -ForegroundColor Yellow
        Stop-Process -Name outlook -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
    } else {
        Write-Host "Outlook est ouvert. Ferme Outlook puis relance (ou utilise -ForceCloseOutlook)." -ForegroundColor Red
        exit 1
    }
}

foreach ($ver in $OfficeVersions) {

    $policyPath = "HKCU:\Software\Policies\Microsoft\Office\$ver\Outlook\Cached Mode"
    $userPath   = "HKCU:\Software\Microsoft\Office\$ver\Outlook\Cached Mode"

    $results = [ordered]@{
        Version = $ver
        PolicyPathWritable = $false
        UserPathWritten    = $false
    }

    #Tentative côté Policies
    $p1 = Try-SetRegDword -Path $policyPath -Name "Enable"              -Value 1
    $p2 = Try-SetRegDword -Path $policyPath -Name "SyncWindowSetting"   -Value $MonthsToKeepOffline
    $p3 = Try-SetRegDword -Path $policyPath -Name "SyncWindowSettingDays" -Value 0
    $results.PolicyPathWritable = ($p1 -or $p2 -or $p3)

    if (-not $results.PolicyPathWritable) {
        Write-Host "Policies verrouillé (normal en entreprise) -> on applique en préférences utilisateur." -ForegroundColor DarkYellow
    } else {
        Write-Host "Policies OK : réglages appliqués." -ForegroundColor Green
    }

    #écrire aussi côté utilisateur
    $u1 = Try-SetRegDword -Path $userPath -Name "SyncWindowSetting"     -Value $MonthsToKeepOffline
    $u2 = Try-SetRegDword -Path $userPath -Name "SyncWindowSettingDays" -Value 0
    $null = Try-SetRegDword -Path $userPath -Name "Enable"             -Value 1

    $results.UserPathWritten = ($u1 -and $u2)

    if ($results.UserPathWritten) {
        Write-Host "OK (Office $ver) : $MonthsToKeepOffline mois hors connexion configurés." -ForegroundColor Green
    } else {
        Write-Host "Échec d'écriture dans $userPath (droits ou registre bloqué)." -ForegroundColor Red
    }

    #Affiche ce qui est réellement écrit
    try {
        $read = Get-ItemProperty -Path $userPath -ErrorAction Stop
        Write-Host ("Valeurs actuelles (User) : SyncWindowSetting={0}, SyncWindowSettingDays={1}" -f $read.SyncWindowSetting, $read.SyncWindowSettingDays) -ForegroundColor Cyan
    } catch {
        Write-Host "Impossible de relire les valeurs dans $userPath." -ForegroundColor DarkYellow
    }
}

Write-Host "Terminé. Relance Outlook : il synchronisera jusqu’à 1 an d’historique" -ForegroundColor Cyan
