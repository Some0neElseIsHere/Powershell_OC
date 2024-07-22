###
### Version 1.0  (avec les corrections)                  
### Auteur: FOURGOUS Alexandre     
###                                
### Lister les membres d'un groupe
###
# Pour lancer la cmd en PS, exemple:  & C:\Scripts\Projet05_Fourgous_Script02.ps1 -group GG_direction

param (
    #Information à définir pour la fonction ListerMembredGroup
    [parameter(Mandatory=$true)][string] $group = "", #obligation de fournir cette information
    [string] $fileout = "E:\script02-out.txt", #destination de la liste
    #Information à définir pour la fonction TraceLog
    [string] $logPath = "C:\log.txt", # destination du fichier de log en cas d erreur
    [string] $script = "Script 2",
    [string] $level = "Error" # a definir en fonction de la criticite de son utilisation
    )

function ListerMembredGroup($groupname)
{   Try
	{	# Test de la commande sans créer le fichier en cas d'erreur. Sinon un fichier vide se créerai
        $list = Get-ADGroupMember $groupname | Select name
        # Sans erreur, on affiche la liste, et on l'envoie dans le fichier defini
        Write-Output $list | Out-file -FilePath $fileout
        TraceLog "INFO" "Les membres du groupe $groupname ont ete listes"
        Write-Host "Les membres du groupe"$groupname "ont ete listes a l'adresse suivante:" $fileout
	}
	Catch
	{	#Renvoie de l'erreur
        Write-host "Une erreur est survenue "
        # Report de l'info
		TraceLog "ERROR" $error[0]
	}
}

# 
# Fonction TraceLog: Trace le fonctionnement du script
#
# Param string $level niveau de la trace: [trace|debug|info|warn|error|critical|fatal][message]
# Param string $msg message à tracer.
#
function TraceLog($level, $msg)
{	$level = $level.ToUpper()
    $date = get-date -format "yyyy MM dd - HH mm ss"
    $messagecomplet = $date +" ["+$level+"] "+$script+" - "+$msg
    #On envoie le contenu de l'erreur vers $logpath avec l'ensemble des informations
	ADD-content -path $logPath -value $messagecomplet
    if($level -eq "ERROR")
    {
        Exit 1
    }
}

ListerMembredGroup $group 

Exit 0