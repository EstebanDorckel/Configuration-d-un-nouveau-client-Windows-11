Write-Host "======================================================="                                                                -ForegroundColor Cyan
Write-Host "========= RENTRER LA MACHINE DANS LE DOMAINE ==========" 																-ForegroundColor Cyan
Write-Host "======================================================="                                                                -ForegroundColor Cyan
# Saisie des informations
$DomainName = Read-Host "Entrez le nom du domaine (ex: domaine.local)"
$DomainUser = Read-Host "Entrez un identifiant administrateur du domaine (ex: domaine\adm.uitilisateur)"

# Demande du mot de passe
$DomainPassword = Read-Host "Mot de passe" -AsSecureString

# --- Création de l'objet credential ---
$Credential = New-Object System.Management.Automation.PSCredential($DomainUser, $DomainPassword)

# --- Préparation des paramètres pour Add-Computer ---
$AddComputerParams = @{
    DomainName = $DomainName
    Credential = $Credential
    Restart    = $true
    Force      = $true
    Verbose    = $true
}

if ($OUPath.Trim() -ne "") { $AddComputerParams.Add("OUPath", $OUPath) }
if ($NewComputerName.Trim() -ne "") { $AddComputerParams.Add("NewName", $NewComputerName) }

# --- Jointure au domaine ---
try {
    Add-Computer @AddComputerParams
    Write-Host "Opération réussie ! L'ordinateur va redémarrer et rejoindra le domaine $DomainName" 									-ForegroundColor Green
}
catch {
    Write-Error "Échec de la jointure au domaine : $($_.Exception.Message)"
    Write-Host "Vérifiez le nom de domaine, les DNS, les droits du compte et la connectivité réseau." 									-ForegroundColor RedWrite-Host "========= RENTRER LA MACHINE DANS LE DOMAINE ==========" 											-ForegroundColor Cyan
						Write-Host ""

					# Saisie des informations
					$DomainName = Read-Host "Entrez le nom du domaine (ex: entreprise.local)"
					$DomainUser = Read-Host "Entrez l'identifiant admin du domaine (ex: domaine\adm.utilisateur)"

					# Demande de mot de passe
					$DomainPassword = Read-Host "Mot de passe pour $DomainUser" -AsSecureString

					# Création de l'objet credential
					$Credential = New-Object System.Management.Automation.PSCredential($DomainUser, $DomainPassword)

					# Préparation des paramètres pour Add-Computer
					$AddComputerParams = @{
						DomainName = $DomainName
						Credential = $Credential
						Restart    = $true
						Force      = $true
						Verbose    = $true
					}

					if ($OUPath.Trim() -ne "") { $AddComputerParams.Add("OUPath", $OUPath) }
					if ($NewComputerName.Trim() -ne "") { $AddComputerParams.Add("NewName", $NewComputerName) }

					# Jointure au domaine
					try {
						Add-Computer @AddComputerParams
						Write-Host "Opération réussie ! L'ordinateur va redémarrer et rejoindra le domaine $DomainName" 				-ForegroundColor Green
					}
					catch {
						Write-Error "Échec de la jointure au domaine : $($_.Exception.Message)"
						Write-Host "Vérifiez le nom de domaine et la connectivité réseau." 												-ForegroundColor Red
					}
					}
pause
exit