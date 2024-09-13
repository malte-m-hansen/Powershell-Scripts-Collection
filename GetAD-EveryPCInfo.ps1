#Start med at få liste af computere fra AD, som CSV format
Get-ADComputer -Filter * -Property * | Select-Object Name | Export-CSV ADcomputerslist.csv -NoTypeInformation -Encoding UTF8

#Definer $AllComputers som den impoterede CSV 
$AllComputers = Import-Csv .\ADcomputerslist.csv

#Lav ForEach for hver computer
$AllComputers | ForEach-Object {

    $pcname = $_.Name #Definer $pcname som den aktutelle computer 
    $date = Get-Date #Definer $date som det nuværende tidspunkt. Disse to opdatere hver gang ForEach "starter forfra"
    #Starter med at ping computer, hvis der ikke kommer svar, skriver den til output, går den til næste computer.
    if (-not (Test-Connection -comp $pcname -quiet)) {
        Write-host "$_ is down" -ForegroundColor Red
        Write-Output " " 
        $pcname + " is down. Cant read information!" | Out-File -FilePath C:\temp\testlog.txt -Append
        " "| Out-File -FilePath C:\temp\testlog.txt -Append
    }
    Else {
        #Hvis ping er sucessfull, så tjekker den om der kan hentes WMI data fra computerem
        #Hvis man ikke kan få WMI data, skriver den til output, og går vidre til næste computer
        if (-not ( $computerSystem = Get-CimInstance CIM_ComputerSystem -ComputerName $pcname)) {
            Write-Output " "
            $pcname + " is online, but info cant be read from the device
                  " | Out-File -FilePath C:\temp\testlog.txt -Append
        }  
        else {
            #Definere "ComputerXXX" som CIM instance værdier for nuværende PC navn
            $computerSystem = Get-CimInstance CIM_ComputerSystem -ComputerName $pcname
            $computerBIOS = Get-CimInstance CIM_BIOSElement -ComputerName $pcname
            $computerOS = Get-CimInstance CIM_OperatingSystem -ComputerName $pcname
            $computerCPU = Get-CimInstance CIM_Processor -ComputerName $pcname
            #Tager kun info på C drev
            $computerHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'" -ComputerName $pcname
            $computerVideo = Get-CimInstance win32_VideoController -ComputerName $pcname
            Clear-Host
  
            Write-Output "" 
                                                                #Skriver hver linje til output
            "---------" + $Date.ToUniversalTime() + "---------" | Out-File -FilePath C:\temp\testlog.txt -Append
            "System Info for: "     + $pcname | Out-File -FilePath C:\temp\testlog.txt -Append
            "Manufacturer: "        + $computerSystem.Manufacturer | Out-File -FilePath C:\temp\testlog.txt -Append
            "Model: "               + $computerSystem.Model | Out-File -FilePath C:\temp\testlog.txt -Append
            "Operating System: "    + $computerOS.caption + ", Version: " + $computerOS.Version | Out-File -FilePath C:\temp\testlog.txt -Append
            "OS install Date: "     + $computerOS.InstallDate | Out-File -FilePath C:\temp\testlog.txt -Append
            "Video Card: "          + $computerVideo.VideoProcessor | Out-File -FilePath C:\temp\testlog.txt -Append
            "HDD Capacity: "        + "{0:N2}" -f ($computerHDD.Size / 1GB) + "GB" | Out-File -FilePath C:\temp\testlog.txt -Append
            "HDD Free Space: "      + "{0:P2}" -f ($computerHDD.FreeSpace / $computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace / 1GB) + "GB)" | Out-File -FilePath C:\temp\testlog.txt -Append
            "RAM: "                 + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory / 1GB) + "GB" | Out-File -FilePath C:\temp\testlog.txt -Append
            "Serial Number: "       + $computerBIOS.SerialNumber | Out-File -FilePath C:\temp\testlog.txt -Append
            "CPU: "                 + $computerCPU.Name | Out-File -FilePath C:\temp\testlog.txt -Append
            "CPU cores: "           + $computerCPU.NumberOfLogicalProcessors | Out-File -FilePath C:\temp\testlog.txt -Append
            "User logged In: "      + $computerSystem.UserName | Out-File -FilePath C:\temp\testlog.txt -Append
            "Last Reboot: "         + $computerOS.LastBootUpTime | Out-File -FilePath C:\temp\testlog.txt -Append
            " " | Out-File -FilePath C:\temp\testlog.txt -Append #Skriver en tom linje
            Write-Host "Finished" $pcname #Skriver i terminal hvilken pc den er færdig med
        }
    } 
}
Read-Host -Prompt "Press Enter to exit"