function Test-IsAdmin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p  = New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
#lancement de powershell en admin
if (-not (Test-IsAdmin)) {
    Write-Host "Relance en administrateur..."                                                                                           -ForegroundColor Yellow
    Start-Process -FilePath "powershell.exe" -ArgumentList @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-File", "`"$PSCommandPath`""
    ) -Verb RunAs
    Exit
}

function Ensure-RegistryKey {
    param([Parameter(Mandatory)] [string] $Path)
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
}

function Set-RegValue {
    param(
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [string] $Name,
        [Parameter(Mandatory)] $Value,
        [ValidateSet("DWord","String")] [string] $Type = "DWord"
    )
    Ensure-RegistryKey -Path $Path
    if ($Type -eq "DWord") {
        New-ItemProperty -Path $Path -Name $Name -Value ([int]$Value) -PropertyType DWord -Force | Out-Null
    } else {
        New-ItemProperty -Path $Path -Name $Name -Value ([string]$Value) -PropertyType String -Force | Out-Null
    }
}

function Restart-Explorer {
    Write-Host "Redémarrage d'Explorer (barre des tâches)..."                                                                               -ForegroundColor Cyan
    Get-Process explorer -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Process explorer.exe
}

function Unpin-FromTaskbarByName {
    param(
        [Parameter(Mandatory)] [string[]] $AppNames
    )
#mdification de la barre des taches
    $verbsToMatch = @(
        'Unpin from taskbar',
        'Détacher de la barre des tâches',
        'Désépingler de la barre des tâches',
        'Retirer de la barre des tâches'
    )

    $shell = New-Object -ComObject Shell.Application
    $appsFolder = $shell.NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}')

    foreach ($n in $AppNames) {
        try {
            $item = $appsFolder.Items() | Where-Object { $_.Name -eq $n } | Select-Object -First 1
            if (-not $item) { continue }

            $did = $false
            foreach ($v in $item.Verbs()) {
                $vn = ($v.Name -replace '&','').Trim()
                if ($verbsToMatch | Where-Object { $vn -like "*$_*" }) {
                    $v.DoIt()
                    $did = $true
                    break
                }
            }

            if ($did) {
                Write-Host "Désépinglé de la barre des tâches : $n"                                                                           -ForegroundColor Green
            }
        } catch {           
        }
    }
}

function Add-BlockedOobeUpdater {
    param([Parameter(Mandatory)] [string] $UpdaterToken)
#bloquage du nouvel outlook
    $path = "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe"
    Ensure-RegistryKey -Path $path
#bloque de la réinstallation
    $name = "BlockedOobeUpdaters"
    $current = (Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue).$name

    $arr = @()
    if ($current) {
        try { $arr = ($current | ConvertFrom-Json) } catch { $arr = @() }
    }
    if ($arr -notcontains $UpdaterToken) { $arr += $UpdaterToken }

    $json = ($arr | ConvertTo-Json -Compress)
    Set-RegValue -Path $path -Name $name -Value $json -Type String
    Write-Host "Blocage OOBE ajouté : $json" -ForegroundColor Green
}

$build = [System.Environment]::OSVersion.Version.Build
Write-Host "Windows build: $build"                                                                                                              -ForegroundColor DarkGray
#masque la vue des taches
Set-RegValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 -Type DWord
Write-Host "Bouton 'Tâches / Task View' masqué."                                                                                                -ForegroundColor Green
#reglage de la barre des taches
Set-RegValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0 -Type DWord
Write-Host "Bouton 'Widgets' masqué (HKCU TaskbarDa=0)."                                                                                        -ForegroundColor Green

Set-RegValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" -Name "AllowNewsAndInterests" -Value 0 -Type DWord
Write-Host "Policy Widgets/News&Interests désactivée (HKLM AllowNewsAndInterests=0)."                                                           -ForegroundColor Green

Unpin-FromTaskbarByName -AppNames @(
    "Microsoft Store",
    "Boutique Microsoft",
    "Store"
)
#suppression de la barre des taches du microsoft store
Set-RegValue -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoPinningStoreToTaskbar" -Value 1 -Type DWord
Write-Host "Policy: empêche l'épinglage Microsoft Store à la barre des tâches (NoPinningStoreToTaskbar=1)."                                     -ForegroundColor Green

#suppression du nouvel outlook de la barre des taches
Unpin-FromTaskbarByName -AppNames @(
    "Outlook (new)",
    "Outlook (nouveau)",
    "Nouvel Outlook",
    "New Outlook"
)

$pkgs = Get-AppxPackage -AllUsers -Name "Microsoft.OutlookForWindows" -ErrorAction SilentlyContinue
foreach ($p in $pkgs) {
    try {
        Remove-AppxPackage -Package $p.PackageFullName -AllUsers -ErrorAction SilentlyContinue
        Remove-AppxPackage -Package $p.PackageFullName -ErrorAction SilentlyContinue
    } catch { }
}
if ($pkgs) {
    Write-Host "Outlook (new) désinstallé (appx)."                                                                                              -ForegroundColor Green
} else {
    Write-Host "Outlook (new) non trouvé côté Appx (Microsoft.OutlookForWindows)."                                                              -ForegroundColor Yellow
}

$prov = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq "Microsoft.OutlookForWindows" }
foreach ($pp in $prov) {
    try {
        Remove-AppxProvisionedPackage -Online -PackageName $pp.PackageName -ErrorAction SilentlyContinue | Out-Null
        Write-Host "Outlook (new) retiré des packages provisionnés."                                                                            -ForegroundColor Green
    } catch { }
}

Add-BlockedOobeUpdater -UpdaterToken "MS_Outlook"

Set-RegValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0 -Type DWord

Ensure-RegistryKey -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarAl"
Set-RegValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarAl" -Name "SystemSettings_DesktopTaskbar_Al" -Value "0" -Type String

Write-Host "Alignement barre des tâches : gauche."                                                                                              -ForegroundColor Green

Write-Host "Terminé."                                                                                                                           -ForegroundColor Cyan