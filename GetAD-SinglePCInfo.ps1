Get-ADComputer -Filter * | Format-Table -Property Name > C:\temp\adcomputernames.txt
Get-Content C:\temp\adcomputernames.txt | Measure-Object -Line > C:\temp\adcomputerslinecount.txt
$linefull = (Get-Content C:\temp\adcomputerslinecount.txt)[3]
$linemax = $linefull.Trim()
Write-Host "Linemax = " $linemax


$line = 3
$pcfull = (Get-Content C:\temp\adcomputernames.txt)[$line]
$pcname = $pcfull.Trim()


	While ($line -lt $linemax) {
		$computerSystem = Get-CimInstance CIM_ComputerSystem -ComputerName $pcname
		$computerBIOS = Get-CimInstance CIM_BIOSElement -ComputerName $pcname
		$computerOS = Get-CimInstance CIM_OperatingSystem -ComputerName $pcname
		$computerCPU = Get-CimInstance CIM_Processor -ComputerName $pcname
		$computerHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'" -ComputerName $pcname
		Clear-Host
		
		Write-Host  "
		
""System Information for: " $computerSystem.Name -BackgroundColor DarkCyan
		"Manufacturer: " + $computerSystem.Manufacturer
		"Model: " + $computerSystem.Model
		"Serial Number: " + $computerBIOS.SerialNumber
		"CPU: " + $computerCPU.Name
		"HDD Capacity: "  + "{0:N2}" -f ($computerHDD.Size/1GB) + "GB"
		"HDD Space: " + "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
		"RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"
		"Operating System: " + $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion
		"User logged In: " + $computerSystem.UserName
		"Last Reboot: " + $computerOS.LastBootUpTime
		$line = $line + 1




}
Read-Host -Prompt "Press Enter to exit"