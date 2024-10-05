###
### Version 1.0    
###                                
### Sauvegarde Quotidienne
###

function DailySave ()
{   Try
    {   # On récupère le login de l'utilisateur, ainsi que le nom de l'ordinateur
        $login = [system.environment]::Username
        $machine = [system.environment]::MachineName
        # Différents level de chemin pour les dossiers à sauvegarder sur serveur: SAV -> Nom ordinateur -> Nom utilisateur.
        $path1 = "\\192.168.10.1\SAV\"
        $path2 = $path1+$machine+"\"
        $path3 = $path2+$login

        # On crée le dossier correspondant à l'ordinateur destiné à la sauvegarde
        New-Item -Name $machine -ItemType Directory -Path $path1 -Force | Out-Null #Silencieux
        # On crée le dossier corespondant à l'utilisateur destiné à la sauvegarde
        TraceLog "INFO" "Creation du dossier $path2"
        # On crée un sous repertoire correspondant à l'utilisateur de l'ordinateur précédant
        New-Item -Name $login -ItemType Directory -Path $path2 -Force | Out-Null #Silencieux
        # On crée le dossier corespondant à l'utilisateur destiné à la sauvegarde
        TraceLog "INFO" "Creation du dossier $path3"

        # On copie les fichiers et sous-dossiers en écransant si besoin l'ancienne sauvegarde
        # Ici on copie uniquement le dossier Documents dans le répertoire de l'utilisateur.
        Copy-Item -Path C:\Users\$login\Documents -Destination $path3 -Recurse -Force
        TraceLog "INFO" "Sauvegarde de $machine $login"
    }
    Catch
    {
        TraceLog "ERROR" "Erreur dans la sauvegarde $machine $login"
    }
}

# 
# Fonction TraceLog: Trace le fonctionnement du script
#
# $level niveau de la trace: [trace|debug|info|warn|error|critical|fatal][message]
# $msg message à tracer.
#
function TraceLog($level, $msg)
{	$level = $level.ToUpper()
    $script = "Script 4"
    $logPath = "\\192.168.10.1\SAV\log.txt"
    $date = get-date -format "yyyy MM dd - HH mm ss"
    $messagecomplet = $date +" ["+$level+"] "+$script+" - "+$msg
    #On envoie le contenu de l'erreur vers $logpath avec l'ensemble des informations
	ADD-content -path $logPath -value $messagecomplet
    if($level -eq "ERROR")
    {
        Exit 1
    }
}

DailySave

Exit 0
