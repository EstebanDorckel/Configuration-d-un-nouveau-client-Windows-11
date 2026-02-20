function Start-ScriptWindow {
    param(
        [Parameter(Mandatory)][string]$ScriptPath,
        [switch]$AsAdmin
    )

    if (-not (Test-Path $ScriptPath)) {
        Write-Host "Script introuvable : $ScriptPath" -ForegroundColor Red
        pause
        return
    }

#securite pour les chemins
    $safePath = $ScriptPath -replace "'", "''"

    $cmd = "chcp 65001 > `$null; & '$safePath'; Write-Host ''; Write-Host 'Appuyez sur une touche pour revenir au menu...' -ForegroundColor Yellow; pause"

    $args = @(
        "-NoProfile",
        "-ExecutionPolicy", "Bypass",
        "-Command", $cmd
    )

    if ($AsAdmin) {
        Start-Process -FilePath "powershell.exe" -Verb RunAs -ArgumentList $args
    } else {
        Start-Process -FilePath "powershell.exe" -ArgumentList $args
    }
}

# =================================================================================================================
#  Menu principal
# =================================================================================================================
do {
    Clear-Host
    Write-Host "=================== MENU PRINCIPAL ====================" -ForegroundColor Cyan
    Write-Host "=           A : CONFIGURATION DU SYSTEME              =" -ForegroundColor DarkGreen
    Write-Host "=           B : LOGICIELS                             =" -ForegroundColor DarkGreen
    Write-Host "=           C : WINDOWS 11 (interface user)           =" -ForegroundColor DarkGreen
    Write-Host "=           D : ORDINATEUR PORTABLE                   =" -ForegroundColor DarkGreen
    Write-Host "=           E : FACULTATIF                            =" -ForegroundColor DarkGreen
    Write-Host "=           F : CHAISE MUSICAL                        =" -ForegroundColor DarkGreen
    Write-Host "=           G : Quitter                               =" -ForegroundColor DarkGreen
    Write-Host "=======================================================" -ForegroundColor Cyan
    Write-Host ""
    $choix = Read-Host "Votre choix"

    switch ($choix.ToUpper()) {

        # ==========================================================================================================
        # A - CONFIG SYSTEME
        # ==========================================================================================================
        "A" {
            do {
                Clear-Host
                Write-Host "============== CONFIGURATION DU SYSTEME ==============" -ForegroundColor Cyan
                Write-Host "=       1 : CHANGER LE NOM DE LA MACHINE             =" -ForegroundColor DarkGreen
                Write-Host "=       2 : RENTRER LA MACHINE DANS LE DOMAINE       =" -ForegroundColor DarkGreen
                Write-Host "=       3 : DESACTIVER LE FIREWALL WINDOWS           =" -ForegroundColor DarkGreen
                Write-Host "=       4 : DESACTIVER L'IPV6                        =" -ForegroundColor DarkGreen
                Write-Host "=       0 : RETOUR AU MENU PRINCIPAL                 =" -ForegroundColor DarkGreen
                Write-Host "======================================================" -ForegroundColor Cyan
                Write-Host ""
                $sousChoix = Read-Host "Votre choix"

                switch ($sousChoix) {
                    "1" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\###Scripts_systeme\Script_nomPC.ps1'          -AsAdmin }
                    "2" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\###Scripts_systeme\Script_domaine.ps1'        -AsAdmin }
                    "3" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\###Scripts_systeme\Script_firewall.ps1'       -AsAdmin }
                    "4" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\###Scripts_systeme\Script_ipv6.ps1'           -AsAdmin }
                    "0" { Write-Host "========= RETOUR AU MENU PRINCIPAL =========="                       -ForegroundColor Cyan }
                    default { Write-Host "Choix incorrect !"                                         -ForegroundColor Red; pause }
                }

                if ($sousChoix -ne "0") {
                    Write-Host "`nAppuyez sur une touche pour continuer..." -ForegroundColor Gray
                    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                }

            } while ($sousChoix -ne "0")
        }

        # ===============================================================================================================
        # B - LOGICIELS
        # ===============================================================================================================
        "B" {
            do {
                Clear-Host
                Write-Host "===================== LOGICIELS =====================" -ForegroundColor Cyan
                Write-Host "=           1 : TEST CLAVIER (FR/BG)                =" -ForegroundColor DarkGreen
                Write-Host "=           2 : ESET ANTIVIRUS                      =" -ForegroundColor DarkGreen
                Write-Host "=           3 : MS OFFICE 2021                      =" -ForegroundColor DarkGreen
                Write-Host "=           4 : SAP                                 =" -ForegroundColor DarkGreen
                Write-Host "=           5 : OCS                                 =" -ForegroundColor DarkGreen
                Write-Host "=           6 : IBM CLIENT ACCESS                   =" -ForegroundColor DarkGreen
                Write-Host "=           7 : ACROBAT READER                      =" -ForegroundColor DarkGreen
                Write-Host "=           8 : IRFANVIEW                           =" -ForegroundColor DarkGreen
                Write-Host "=           9 : IMPRIMANTES RESEAU                  =" -ForegroundColor DarkGreen
                Write-Host "=           10 : IMPRIMANTE LOCALE                  =" -ForegroundColor DarkGreen
                Write-Host "=           11 : PONT ODBC GRANGES                  =" -ForegroundColor DarkGreen
                Write-Host "=           0 : RETOUR AU MENU PRINCIPAL            =" -ForegroundColor DarkGreen
                Write-Host "=====================================================" -ForegroundColor Cyan
                Write-Host ""
                $sousChoix = Read-Host "Votre choix"

                switch ($sousChoix) {
                    "1" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\##Scripts_logiciels_obligatoire\Script_test_clavier.ps1'   -AsAdmin }
                    "2" {
                        do {
                            Clear-Host

                            Write-Host "============= GESTION ESET =============" -ForegroundColor Cyan
                            Write-Host "=      1 : Installer ESET              =" -ForegroundColor DarkGreen
                            Write-Host "=      2 : Verifier la version d'ESET  =" -ForegroundColor DarkGreen
                            Write-Host "=      0 : Retour                      =" -ForegroundColor DarkGreen
                            Write-Host "========================================" -ForegroundColor Cyan
                            Write-Host ""
                            $choixEset = Read-Host "Votre choix"

                            switch ($choixEset) {
                                "1" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\##Scripts_logiciels_obligatoire\Script_install_eset.ps1' -AsAdmin }
                                "2" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\##Scripts_logiciels_obligatoire\Script_version_eset.ps1' -AsAdmin }
                                "0" { Write-Host "========= RETOUR AU MENU LOGICIELS ==========" -ForegroundColor Cyan }
                                default { Write-Host "Choix incorrect !" -ForegroundColor Red; pause }
                            }
                        } while ($choixEset -ne "0")
                    }

                    "7" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\##Scripts_logiciels_obligatoire\Script_install_adobe.ps1'   -AsAdmin }

                    "0" { Write-Host "========= RETOUR AU MENU PRINCIPAL ==========" -ForegroundColor Cyan }
                    default { Write-Host "Option non implémentée pour le moment." -ForegroundColor Yellow; pause }
                }

                if ($sousChoix -ne "0") {
                    Write-Host "`nAppuyez sur une touche pour continuer..." -ForegroundColor Gray
                    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                }

            } while ($sousChoix -ne "0")
        }

        # ===================================================================================================================
        # C - WINDOWS 11 (user)
        # ===================================================================================================================
        "C" {
            do {
                Clear-Host
                Write-Host "=========== WINDOWS 11 (interface user) =========" -ForegroundColor Cyan
                Write-Host "=           1 : EXPLORATEUR DE FICHIERS         =" -ForegroundColor DarkGreen
                Write-Host "=           2 : BARRE DES TACHES                =" -ForegroundColor DarkGreen
                Write-Host "=           3 : MISE EN CACHE OUTLOOK           =" -ForegroundColor DarkGreen
                Write-Host "=           4 : ECRAN ET VEILLE                 =" -ForegroundColor DarkGreen
                Write-Host "=           0 : RETOUR AU MENU PRINCIPAL        =" -ForegroundColor DarkGreen
                Write-Host "=================================================" -ForegroundColor Cyan
                Write-Host ""
                $sousChoix = Read-Host "Votre choix"

                switch ($sousChoix) {
                    "1" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\##Scripts_logiciels_obligatoire\Script_Windows11\Script_explorateur_fic.ps1'          -AsAdmin }
                    "2" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\##Scripts_logiciels_obligatoire\Script_Windows11\Script_barre_taches.ps1'             -AsAdmin }
                    "3" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\##Scripts_logiciels_obligatoire\Script_Windows11\Script_mise_en_cache_outlook.ps1'    -AsAdmin }
                    "4" { Start-ScriptWindow -ScriptPath 'C:\Users\dorckele\Desktop\'                                                                           -AsAdmin }
                    "0" { Write-Host "========= RETOUR AU MENU LOGICIELS =========="                                                               -ForegroundColor Cyan }
                }

            } while ($sousChoix -ne "0")
        }

        # ===================================================================================================================
        # D - ORDINATEURS PORTABLES
        # ===================================================================================================================

        "D" {            do {
                Clear-Host
                Write-Host "=========== ORDINATEUR PORTABLE =========" -ForegroundColor Cyan
                Write-Host "=        1 : OPTION D'ALIMENTATION      =" -ForegroundColor DarkGreen
                Write-Host "=        2 : VPN                        =" -ForegroundColor DarkGreen
                Write-Host "=        3 : WHITELIST WIFI EUROFOIL    =" -ForegroundColor DarkGreen
                Write-Host "=        4 : N/A                        =" -ForegroundColor DarkGreen
                Write-Host "=        0 : RETOUR AU MENU PRINCIPAL   =" -ForegroundColor DarkGreen
                Write-Host "=========================================" -ForegroundColor Cyan
                Write-Host ""
                $sousChoix = Read-Host "Votre choix"

                switch ($sousChoix) {
                    "1" { Start-ScriptWindow -ScriptPath 'C:\Users\dorckele\Desktop\'                                                                        -AsAdmin }
                    "2" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\##Scripts_logiciels_obligatoire\Script_PCPortable\Script_fortigate_conf.ps1'       -AsAdmin }
                    "3" { Start-ScriptWindow -ScriptPath 'C:\Users\dorckele\Desktop\'                                                                        -AsAdmin }
                    "4" { Start-ScriptWindow -ScriptPath 'C:\Users\dorckele\Desktop\'                                                                        -AsAdmin }
                    "0" { Write-Host "========= RETOUR AU MENU LOGICIELS =========="                                                            -ForegroundColor Cyan }
                }

            } while ($sousChoix -ne "0")
        }

        # ==================================================================================================================
        # E - FACULTATIF
        # ==================================================================================================================
        "E" {            do {
                Clear-Host
                Write-Host "=============== FACULTATIF =============" -ForegroundColor Cyan
                Write-Host "=       1 : DUD_EXPLORER               =" -ForegroundColor DarkGreen
                Write-Host "=       2 : MAJ AUTO JAVA              =" -ForegroundColor DarkGreen
                Write-Host "=       3 : PANNEAU LIMINEUX           =" -ForegroundColor DarkGreen
                Write-Host "=       4 : MINITAB                    =" -ForegroundColor DarkGreen
                Write-Host "=       5 : MS PROJECT                 =" -ForegroundColor DarkGreen
                Write-Host "=       6 : MS VISIO                   =" -ForegroundColor DarkGreen
                Write-Host "=       7 : WMI                        =" -ForegroundColor DarkGreen
                Write-Host "=       8 : AUTOCAD                    =" -ForegroundColor DarkGreen
                Write-Host "=       9 : POWERDRAFT                 =" -ForegroundColor DarkGreen
                Write-Host "=       0 : RETOUR AU MENU PRINCIPAL   =" -ForegroundColor DarkGreen
                Write-Host "========================================" -ForegroundColor Cyan
                Write-Host ""
                $sousChoix = Read-Host "Votre choix"

                switch ($sousChoix) {
                    "1" { Start-ScriptWindow -ScriptPath 'C:\Users\dorckele\Desktop\'                                                                           -AsAdmin }
                    "2" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\#Script_logiciels_facultatif\Script_maj_java.ps1'                                     -AsAdmin }
                    "3" { Start-ScriptWindow -ScriptPath 'C:\Users\dorckele\Desktop\'                                                                           -AsAdmin }
                    "4" { Start-ScriptWindow -ScriptPath 'C:\Users\dorckele\Desktop\'                                                                           -AsAdmin }
                    "5" { Start-ScriptWindow -ScriptPath 'C:\Users\dorckele\Desktop\'                                                                           -AsAdmin }
                    "6" { Start-ScriptWindow -ScriptPath 'C:\Users\dorckele\Desktop\'                                                                           -AsAdmin }
                    "7" { Start-ScriptWindow -ScriptPath 'C:\Users\dorckele\Desktop\'                                                                           -AsAdmin }
                    "8" { Start-ScriptWindow -ScriptPath 'C:\Users\dorckele\Desktop\'                                                                           -AsAdmin }
                    "9" { Start-ScriptWindow -ScriptPath 'C:\Users\dorckele\Desktop\'                                                                           -AsAdmin }                    
                    "0" { Write-Host "========= RETOUR AU MENU LOGICIELS =========="                                                               -ForegroundColor Cyan }
                    default { }
                }

            } while ($sousChoix -ne "0")
        }
        # ==================================================================================================================
        # F - CHAISE MUSICAL
        # ==================================================================================================================
        "F" {            do {
                Clear-Host
                Write-Host "=============== CHAISE MUSICAL =============" -ForegroundColor Cyan
                Write-Host "=        1 : COPIE DOSSIERS PERSO          =" -ForegroundColor DarkGreen
                Write-Host "=        2 : RESTAURATION BUREAU           =" -ForegroundColor DarkGreen
                Write-Host "=        0 :                               =" -ForegroundColor DarkGreen
                Write-Host "============================================" -ForegroundColor Cyan
                Write-Host ""
                $sousChoix = Read-Host "Votre choix"

                switch ($sousChoix) {
                    "1" {
                        do {
                            Clear-Host

                            Write-Host "=========== COPIE DOSSIERS PERSO =========" -ForegroundColor Cyan
                            Write-Host "=          1 : COPIE BUREAU              =" -ForegroundColor DarkGreen
                            Write-Host "=          2 : COPIE IMAGES              =" -ForegroundColor DarkGreen
                            Write-Host "=          3 : COPIE MUSIQUES            =" -ForegroundColor DarkGreen
                            Write-Host "=          4 : COPIE VIDEOS              =" -ForegroundColor DarkGreen
                            Write-Host "=          5 : COPIE FAVORIS EDGE        =" -ForegroundColor DarkGreen
                            Write-Host "=          6 : COPIE FAVORIS CHROME      =" -ForegroundColor DarkGreen
                            Write-Host "=          7 : COPIE DISQUE D:           =" -ForegroundColor DarkGreen
                            Write-Host "=          8 : COPIE TELECHARGEMENTS     =" -ForegroundColor DarkGreen
                            Write-Host "=          9 : COPIE DOCUMENTS           =" -ForegroundColor DarkGreen                            
                            Write-Host "==========================================" -ForegroundColor Cyan
                            Write-Host ""
                            $choixEset = Read-Host "Votre choix"

                            switch ($choixEset) {
                                "1" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Copie\Script_copie_bureau.ps1'                    -AsAdmin }
                                "2" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Copie\Script_copie_images.ps1'                    -AsAdmin }
                                "3" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Copie\Script_copie_musiques.ps1'                  -AsAdmin }
                                "4" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Copie\Script_copie_videos.ps1'                    -AsAdmin }
                                "5" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Copie\Script_copie_favoris_edge.ps1'              -AsAdmin }
                                "6" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Copie\Script_copie_favoris_chrome.ps1'            -AsAdmin }
                                "7" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Copie\Script_copie_D.ps1'                         -AsAdmin }
                                "8" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Copie\Script_copie_telechargements.ps1'           -AsAdmin }
                                "9" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Copie\Script_copie_documents.ps1'                 -AsAdmin }
                                "0" { Write-Host "========= RETOUR CHAISE MUSICAL =========="                                                      -ForegroundColor Cyan }
                                default { Write-Host "Choix incorrect !"                                                                     -ForegroundColor Red; pause }
                            }
                        } while ($choixEset -ne "0")
                    }  
                    
                    "2" {
                        do {
                            Clear-Host

                            Write-Host "=========== RESTAURATION DOSSIERS PERSO =========" -ForegroundColor Cyan
                            Write-Host "=          1 : RESTAURATION BUREAU              =" -ForegroundColor DarkGreen
                            Write-Host "=          2 : RESTAURATION IMAGES              =" -ForegroundColor DarkGreen
                            Write-Host "=          3 : RESTAURATION MUSIQUES            =" -ForegroundColor DarkGreen
                            Write-Host "=          4 : RESTAURATION VIDEOS              =" -ForegroundColor DarkGreen
                            Write-Host "=          5 : RESTAURATION FAVORIS EDGE        =" -ForegroundColor DarkGreen
                            Write-Host "=          6 : RESTAURATION FAVORIS CHROME      =" -ForegroundColor DarkGreen
                            Write-Host "=          7 : RESTAURATION DISQUE D:           =" -ForegroundColor DarkGreen
                            Write-Host "=          8 : RESTAURATION TELECHARGEMENTS     =" -ForegroundColor DarkGreen
                            Write-Host "=          9 : RESTAURATION DOCUMENTS           =" -ForegroundColor DarkGreen                            
                            Write-Host "=================================================" -ForegroundColor Cyan
                            Write-Host ""
                            $choixEset = Read-Host "Votre choix"

                            switch ($choixEset) {
                                "1" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Restauration\Script_restauration_bureau.ps1'          -AsAdmin }
                                "2" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Restauration\Script_restauration_images.ps1'          -AsAdmin }
                                "3" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Restauration\Script_restauration_musiques.ps1'        -AsAdmin }
                                "4" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Restauration\Script_restauration_videos.ps1'          -AsAdmin }
                                "5" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Restauration\Script_restauration_favoris_edge.ps1'    -AsAdmin }
                                "6" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Restauration\Script_restauration_favoris_chrome.ps1'  -AsAdmin }
                                "7" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Restauration\Script_restauration_D.ps1'               -AsAdmin }
                                "8" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Restauration\Script_restauration_telechargements.ps1' -AsAdmin }
                                "9" { Start-ScriptWindow -ScriptPath 'D:\Scripts_conf\Scripts_chaise_musicale\Restauration\Script_restauration_documents.ps1'       -AsAdmin }
                                "0" { Write-Host "========= RETOUR CHAISE MUSICAL =========="                                                          -ForegroundColor Cyan }
                                default { Write-Host "Choix incorrect !"                                                                         -ForegroundColor Red; pause }
                            }
                        } while ($choixEset -ne "0")
                    }

                    "0" { Write-Host "========= RETOUR AU MENU PRINCIPAL =========="                                                                   -ForegroundColor Cyan }
                    default { Write-Host "Option non implémentée pour le moment."                                                             -ForegroundColor Yellow; pause }
                }

                if ($sousChoix -ne "0") {
                    Write-Host "`nAppuyez sur une touche pour continuer..." -ForegroundColor Gray
                    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                }

            } while ($sousChoix -ne "0")
        }
        # ===================================================================================================================
        # G - FERMETURE DU SCRIPT
        # ===================================================================================================================
        "G" {
            Write-Host "FIN DES OPERATIONS !" -ForegroundColor Green
            break
        }

        default {
            Write-Host "Choix incorrect !" -ForegroundColor Red
            pause
        }
    }

    if ($choix.ToUpper() -ne "E") {
        Write-Host "`nAppuyez sur une touche pour continuer..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }

} while ($choix.ToUpper() -ne "E")