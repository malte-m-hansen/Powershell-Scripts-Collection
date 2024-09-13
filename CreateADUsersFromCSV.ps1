#Spørger bruger hvad fil man skal importere
$csvpath = Read-Host "Path to csv file"
#Laver en Test-Path for at se om filen findes
$testcsvpath = Test-Path -Path $csvpath
#Hvis filen findes
if ($testcsvpath -eq $true) {
    #Importer CSV med brugere
    Import-CSV $csvpath | ForEach-Object {
        #Definer det navn som skal søges efter
        $name = "$($_.first_name)`.$($_.last_name)"
        #Check om brugeren findes
        $check = Get-ADUser -LDAPFilter "(sAMAccountName=$Name)"
        #Hvis brugeren ikke findes
        If ($check -eq $Null) {
            #Opret ny bruger
            New-ADUser -Name $_.first_name -Surname $_.last_name -EmailAddress $_.email -Department $_.department -Title $_.title  -samAccountName "$($_.first_name)`.$($_.last_name)" -AccountPassword $(ConvertTo-SecureString $_.password -AsPlainText -Force) -Path "OU=Users,OU=DK,DC=aplast3d,DC=COM" -Enable $True -ChangePasswordAtLogon $true
            #Skriver til terminal at brugeren er oprettet
            Write-Host "$name has been created"
        }
        #Hvis bruger allerede eksistere
        Else {
            #Skriver til terminal at bruger allerede eksistrer 
            Write-Host "$name allready exists."
            #Next user
        }    
    }
}
#Hvis fil ikke findes
else {
    Write-Host "File not found"
}


