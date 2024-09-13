#Definere DC path
[string] $DC = 'DC=aplast3d,DC=COM'
#Spørger hvad navn på første OU skal være
$ou1name = Read-Host 'Name of first OU (OU in root) (To create new, type a name that does not exist in root)'
#Sætter "ou=" foran ou1name
$OU1 = 'OU=' + $ou1name
#Laver fuld path til OU1
[string] $path1 = $OU1 + "," + $DC

#Tjek om OU1 allerede er lavet
$ou1_exists = [adsi]::Exists("LDAP://$path1")

#Denne function bliver først kørt når man skal til at lave OU2
function CreateOU2 {
    #Spørger hvad OU2 skal hedde
    $ou2name = Read-Host "Name of new OU in $path1"
    #Laver det fulde OU2 navn
    $ou2 = "OU=" + $ou2name
    #Laver fuld sti til at tjekke om OU2 allerede findes
    $path2 =   $ou2 + "," + $path1
    #Tjekker om OU2 findes
    $ou2_exists = [adsi]::Exists("LDAP://$path2")       
        #Hvis OU2 ikke findes, køres dette
        if (-not $ou2_exists) {
            #laver ny OU i OU1
            New-ADOrganizationalUnit -Name "$ou2name" -Path "$path1"
            Write-Host "Created!"
        }
        else {
            #Giver fejl hvis mappe allerede eksistere
            Write-Host "Error. Allready exists, please try again"
            #Beder om navn igen ved at køre function fra starten igen
            CreateOU2
        }
    #End of function
}

#Hvis OU1 ikke eksistere
if (-not $ou1_exists) {
    Write-Host "A OU named $ou1 does not exist in root folder"
    #Spørger om man vil lave OU i root
    $createOU1 = Read-Host "Create new OU named $ou1 in root? (y or n)"
    if ($createOU1 -eq "y") {
        #Hvis der bliver klikket "y" bliver OU1 lavet
        New-ADOrganizationalUnit -Name "$ou1name" -Path "$DC"
        Write-Host "New OU created"
        #Spørger om man vil lave et nyt OU i OU1
        $createOU2 = Read-Host "Create new OU in $path1 (y or n)"
        #Hvis der bliver svarret "y" bliver Function CreateOU2 kørt
        if ($createOU2 -eq "y") {
            CreateOU2 
        }
        elseif ($createou2 -eq "n") {
            #Exit hvis man svarre "n"
        }    
        else {
            Write-Host "Error 40. Wrong input"
            #Exit hvis man svarre noget forkert/andet end y og n
        }
    }

    elseif ($createOU1 -eq "n") {
        #Exit hvis man ikke gider lave OU2
    }
    else {
        Write-Host "Error 40. Wrong input"
        #Exit hvis man skriver forkert
    }
}
else {
    #Kører dette hvis navn allerede eksistere (Hvis man vil lave OU2)
    $createOU2 = Read-Host "OU allready exists! Create new OU in $path1 (y or n)"
    #Kører Function CreateOU2 Hvis man svarre y
    if ($createOU2 -eq "y") {
        CreateOU2 
    }
    elseif ($createou2 -eq "n") {
        #Exit hvis man svarre n
    }    
    else {
        Write-Host "Error 40. Wrong input"
        #Exit hvis man skriver forkert
    }
    
}
Read-Host -Prompt "Press Enter to exit"