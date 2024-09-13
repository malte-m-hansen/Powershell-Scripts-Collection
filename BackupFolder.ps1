#Spørger brugeren hvilken mappe der skal kopiers
$sourcepath = Read-Host 'What folder do you want to copy?'
#Test om stien findes. Giver enten True eller False. Bliver brugt senere
$testsource = Test-Path -Path $sourcepath
#Spørger brugeren hvad navnet på "backup" mappen skal være 
$copyfoldernameinput =  Read-Host 'what should the backup-folder be named'
#Definere hvad stien til den nye mappe skal være, ved at tage $sourcepath og tilføje "/navn på backup mappe"
$copypath = $sourcepath+"\"+$copyfoldernameinput
#tester om der allerede er en mappe der hedder "backup", så man ikke ender med at flytte alle filer, in i en mappe der allerede har filer i sig
$testcopyfolder = Test-Path -Path $copypath

#Hvis source findes
if ($testsource -eq $True) {
    #Skriver til terminal at mappen findes
    Write-Host "Source is valid"
    #tester om der allerede er en mappe med samme navn som backup mappen
    if ($testcopyfolder -eq $True) {
        #Skriver i terminal
        Write-Host "A folder named $copyfoldernameinput allready exists in $sourcepath. Please choose new name"
    }
    #Hvis der ikke er en mappe med navnet 
    else {
        Write-Host "No current backup folder was found. Copying will begin now"
        #Laver færst den nye mappe
        New-Item -Path $sourcepath'\'$copyfoldernameinput -ItemType Directory | Out-Null
        #Kopirer alle filer fra $sourcepath til ny mappe
        Copy-Item -Path $sourcepath\* -Destination $copypath -Exclude $copypath -Recurse -ErrorAction SilentlyContinue
        #Script færdig
        Write-Host "Backup finished. Have a nice day"
    }
}
#Hvis source ikke findes
else {
    #Skriver til terminal
    Write-Host "Source is not valid"
} 
Read-Host -Prompt "Press Enter to exit"