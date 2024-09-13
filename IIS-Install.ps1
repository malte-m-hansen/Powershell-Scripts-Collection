#Spørger burger hvilken server man vil installere på
$servername = Read-Host "What server would you like to install IIS on?"
#Begynder at installere IIS på den valgte server
Install-WindowsFeature -name Web-Server -ComputerName $servername -IncludeManagementTools