###
### Version 1.0  (avec les corrections)                   
###                                
### CREATION D'UN UTILISATEUR + REPERTOIRE PARTAGE
###
# Pour lancer la cmd en PS, exemple:  & C:\Scripts\Projet05_Fourgous_Script01.ps1 -name Doe -prenom John -group GG_direction

param (
    #Information à définir pour la fonction ListerMembredGroup
    [parameter(Mandatory=$true)][string] $name = "", #obligation de fournir cette information
    [parameter(Mandatory=$true)][string] $prenom = "", #obligation de fournir cette information
    [parameter(Mandatory=$true)][string] $group = "", #obligation de fournir cette information
    #Information à définir pour la fonction TraceLog
    [string] $logPath = "C:\log.txt", # destination du fichier de log en cas d erreur
    [string] $script = "Script 1",
    [string] $level = "Error", # a definir en fonction de la criticite de son utilisation
    #Informations invariable lié à ACME.FR
    [string] $phone = "+33(1) 01 01  01 01",
    [string] $fax = "+33(1) 01 01 01 02",
    [string] $website = "www.acme.fr",
    [string] $adress ="100 rue de l'IT",
    [string] $codepostal = "75000",
    [string] $ville = "Paris",
    [string] $domaine = "acme.fr"
    )

function CreateUser()
{   Try
	{	# Le nom de l'utilisateur à créer en majuscule
        $name = $name.ToUpper()
        # On rentre le prénom de l'utilisateur à créer (tout en minuscule sauf la 1ere lettre)
        $prenom = (Get-culture).TextInfo.ToTitleCase($prenom)
        
        # On récupère la 1ere lettre du prénom + le nom complet pour son identifiant (en minuscule)
        # Sauf pour info@acme à faire en manuel.
        $login = ($prenom.Substring(0,1) + $name).ToLower()
        $email = ($prenom.Substring(0,1) + $name + "@" + $domaine).ToLower()

        # Un mot de passe par défaut que l'utilisateur devra changer à sa 1ere connexion.
        $password = $name + ".acme2019"

        TraceLog "INFO" "Creation de l'utilisateur $name"

        # Creation du profil
        New-ADUser -Name $name" "$prenom  -SamAccountName $login -EmailAddress $email -GivenName $prenom -Surname $name -OfficePhone $phone -Fax $fax -StreetAddress $adress -City $ville -PostalCode $codepostal -Homepage $website -UserPrincipalName $login -AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force) -ChangePasswordAtLogon $true -CannotChangePassword $false -Enable $true 
        
        TraceLog "INFO" "Ajout de l'utilisateur au groupe $group"

        #On l'ajoute au group prevu
        Add-ADGroupMember -Identity $group -Members $login
	}
	Catch
	{	#Renvoie de l'erreur
        Write-host "Une erreur est survenue "
        # Report de l'info
		TraceLog "ERROR" $error[0]
	}
}

function CreateFolder()
{   Try
	{	 # Le nom de l'utilisateur à créer en majuscule
        $name = $name.ToUpper()
        # On rentre le prénom de l'utilisateur à créer (tout en minuscule sauf la 1ere lettre)
        $prenom = (Get-culture).TextInfo.ToTitleCase($prenom)
        
        # On récupère la 1ere lettre du prénom + le nom complet pour son identifiant (en minuscule)
        # Sauf pour info@acme à faire en manuel.
        $login = ($prenom.Substring(0,1) + $name).ToLower()

        # le nom du dossier
        $nomdudossier = ($name.ToUpper() + $prenom.Substring(0,1).ToLower())
        # le chemin du dossier où l'on va creer le nouveau dossier
        $chemindudossier = "E:\Shares\DossierP"

        TraceLog "INFO" "Creation du dossier $nomdudossier"
        
        #On crée le dossier
        cd $chemindudossier
        New-Item -Name $nomdudossier -ItemType directory | Out-Null #Silencieux

        TraceLog "INFO" "Partage du dossier $nomdudossier à Administrateurs et $login"
        
        # Et on crée les partages
        New-SmbShare -Name $nomdudossier -path $chemindudossier"\"$nomdudossier -FullAccess Administrateurs | Out-Null #Silencieux
        Grant-SmbShareAccess -Name $nomdudossier -AccountName $login -AccessRight Change | Out-Null #Silencieux

        #Phrase de fin
        Write-Host "L'utilisateur $login et son dossier $nomdudossier ont bien été créés"

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

CreateUser
CreateFolder

Exit 0
