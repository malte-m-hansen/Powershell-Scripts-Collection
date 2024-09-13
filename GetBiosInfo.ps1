#Spørger om man vil læse info fra sin egen computer
$ReadThisPc = Read-Host 'Do you want to read BIOS information from this pc? (y or n)'
#Hvis man svarre y
if ($ReadThisPc -eq "y") {
    #Definere $computerBIOS
    $computerBIOS = Get-CimInstance win32_bios
    Write-Host ""
    "Name: " + $computerBIOS.Name
    "Version: " + $computerBIOS.SMBIOSBIOSVersion
    "Manufactuer: " + $computerBIOS.Manufacturer
    "Bios Version: " + $computerBIOS.Version
    ""
    
    
}
#Hvis man svarre at man IKKE vil læse fra sin egen computer
elseif ($ReadThisPc -eq "n") {
    #Spørger hvad navnet på anden pc er
    $RemotePcName = Read-Host 'Enter other PC Name'
    #Tester om man kan ping/om den er online
    if (-not (Test-Connection -count 1 -comp $RemotePcName -quiet)) {
        Write-Host $RemotePcName + " is down. Cant read information!" 
    }
    Else {
        #Hvis ping er sucessfull, så tjekker den om der kan hentes WMI data fra computerem
        #Denne difinere også $computerBIOS som den remote PC
        if (-not ( $computerBIOS = Get-CimInstance win32_bios -ComputerName $RemotePcName)) {
            Write-Host $RemotePcName + " is online, but info cant be read from the device"
        }  
        else {
            #Skriver info på remote host
            Write-Host ""
            "Name: " + $computerBIOS.Name
            "Version: " + $computerBIOS.SMBIOSBIOSVersion
            "Manufactuer: " + $computerBIOS.Manufacturer
            "Bios Version: " + $computerBIOS.Version
            ""
        }
    }
}
else {
    Write-Host "Error 40. Wrong input :)"
}
Read-Host -Prompt "Press Enter to exit"