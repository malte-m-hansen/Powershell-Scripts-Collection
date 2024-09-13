Get-WMIObject Win32_LogicalDisk | Format-Table Name, VolumeName,DriveType,ProviderName, {$_.Size/1GB}, {$_.FreeSpace/1GB} -autosize
Read-Host -Prompt "Press Enter to exit"