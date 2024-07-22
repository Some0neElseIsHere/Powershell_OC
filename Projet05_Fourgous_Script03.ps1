###
### Version 1.0
### Auteur: FOURGOUS Alexandre
###

##
## Lister les groupes d'un membre
##
# Pour lancer la cmd en PS, exemple:  & C:\Scripts\Projet05_Fourgous_Script03.ps1 -user ba

param (
    #Information à définir pour la fonction ListerMembredGroup
    [parameter(Mandatory=$true)][string] $user = "", #obligation de fournir cette information, nom du compte ex: ba
    [string] $fileout = "E:\script03-out.txt", #destination de la liste
    #Information à définir pour la fonction TraceLog
    [string] $logPath = "C:\log.txt", # destination du fichier de log en cas d erreur
    [string] $script = "Script 3",
    [string] $level = "Error" # a definir en fonction de la criticite de son utilisation
    )

function ListerGroupdMembre($username)
{   Try
	{	# On liste ses groupes 
        $groupesuser = Get-ADPrincipalGroupMembership $username | select name
        $phrasededebut = $username +" est membre des groupes ci dessous"
        Add-Content -Path $fileout -value $phrasededebut
        Foreach($u in $groupesuser)
        {   $nom = $u.name
            $membre = $u.MemberOf

            Add-Content -Path $fileout -value $nom
            Add-Content -Path $fileout -value $membre
        }
        TraceLog "INFO" "Les groupes du membre $username ont ete listes"
        Write-Host "Les groupes du membre"$username "ont ete listes a l'adresse suivante:" $fileout
	}
	Catch
	{	#Renvoie de l'erreur
        Write-host "Une erreur est survenue "
        # Report de l'info
		TraceLog "ERROR" $error[0]
	}
}

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

ListerGroupdMembre $user 

Exit 0