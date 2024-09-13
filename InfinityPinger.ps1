$ip = "1.1.1.1"
$outputFile = "C:\temp\PingLog.txt"
Write-Host "Press Crtl + C to stop"
while ($true) {
test-connection $ip -count 1 | Select-Object @{n='TimeStamp';e={Get-Date}},__SERVER, Address, ProtocolAddress, ResponseTime | out-file -append $outputFile
Start-Sleep 15}

