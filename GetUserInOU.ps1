$CountryCode = "UK" #Land initialer
$CityCode = "LON" #By Initialer
Get-ADUser -Filter * -SearchBase "OU=$CityCode,OU=$CountryCode,OU=Users,OU=Aplast3D,OU=Auto 3D Plast Group,DC=aplast3d,DC=com" > C:\temp\$CityCode-Users.txt #Tager bykode og sætter det i filnavnet