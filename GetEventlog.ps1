#Spørger hvilken PC man vil hente 
[string] $pcname = Read-Host "What pc do you want to get syslog from (Seperate by comma to get from more servers)"
#Spørger hvad navn på output filen skal være 
$output = Read-Host "What should the output file be named (Will be located in C:\temp)"
#laver test på om temp mappe findes
$testTempDir = Test-Path -Path C:\temp
#Hvis temp mappe ikke kan findes
if ($testTempDir -eq $false) {
    #Laver en ny temp mappe og går vidre
    New-Item -Path C:\temp -ItemType Directory | Out-Null
} 
Write-Host "Starting eventlog download from $pcname"
Write-Host "This can take a few minutes. You should go grab a coffe :)"
#Henter eventlog fra $pcname og putter output i $output
Get-EventLog -LogName System -ComputerName $pcname | Out-File -FilePath C:\temp\$output.txt -Append
Write-Host "Done!"
#Åbner fil når den er færdig
C:\temp\$output.txt