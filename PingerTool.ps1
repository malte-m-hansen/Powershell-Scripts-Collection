#Laver en basic form
Function Form {
Add-Type -AssemblyName System.Windows.Forms
$Form = New-Object system.Windows.Forms.Form
#Titel på Formen
$Form.Text = "Pinger"
#Højde og bredde på formen
$Form.width = 260
$Form.height = 200
#Fjerner Maximer og minimer knapper
$Form.MinimizeBox = $False
$Form.MaximizeBox = $False
$Form.WindowState = "Normal"
$Form.SizeGripStyle = "Hide"

#Target IP Label
$Label = New-Object System.Windows.Forms.Label
#Placering af Label
$Label.Location = New-Object System.Drawing.Size(10, 10) 
#Størrelse på Label
$Label.Size = New-Object System.Drawing.Size(60, 20) 
#Text på Label
$Label.Text = "Target IP:"
$Form.Controls.Add($Label) 

#Laver en ny textbox
$TextBox = New-Object System.Windows.Forms.TextBox 
#Placering på textboxen
$TextBox.Location = New-Object System.Drawing.Size(75, 10) 
#Størrelse på tekstbox
$TextBox.Size = New-Object System.Drawing.Size(150, 20) 
$Form.Controls.Add($TextBox) 

#Delay Label
$Label2 = New-Object System.Windows.Forms.Label
$Label2.Location = New-Object System.Drawing.Size(10, 40) 
$Label2.Size = New-Object System.Drawing.Size(60, 20) 
$Label2.Text = "Delay:"
$Form.Controls.Add($Label2) 

#Delay Textbox
$TextBox2 = New-Object System.Windows.Forms.TextBox 
$TextBox2.Location = New-Object System.Drawing.Size(75, 40) 
$TextBox2.Size = New-Object System.Drawing.Size(150, 20) 
$Form.Controls.Add($TextBox2) 

#Count label
$Label3 = New-Object System.Windows.Forms.Label
$Label3.Location = New-Object System.Drawing.Size(10, 70) 
$Label3.Size = New-Object System.Drawing.Size(60, 20) 
$Label3.Text = "Count:"
$Form.Controls.Add($Label3) 

#Ekstra label
$Label4 = New-Object System.Windows.Forms.Label
$Label4.Location = New-Object System.Drawing.Size(10, 100) 
$Label4.Size = New-Object System.Drawing.Size(160, 20) 
$Label4.Text = "Set count to '0' to ping forever"
$Form.Controls.Add($Label4) 

#Textfelt til count
$TextBox3 = New-Object System.Windows.Forms.TextBox 
$TextBox3.Location = New-Object System.Drawing.Size(75, 70) 
$TextBox3.Size = New-Object System.Drawing.Size(150, 20) 
$Form.Controls.Add($TextBox3) 

#Laver en "ok" knap
$OKButton = new-object System.Windows.Forms.Button
$OKButton.Location = '100,120'
$OKButton.Size = '100,30' 
$OKButton.Text = 'Run'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.AddRange(@($OKButton)),
#Hvad der skal ske når man klikker på knappen
$OKButton.Add_Click(
{
    #Definer $ip som det tekst der står i TextBox
    $ip = $TextBox.Text
    #Definer $delay som det tekst der står i TextBox2
    $delay = $TextBox2.Text
    #Definer $count som det tekst der står i TextBox3
    $count = $TextBox3.Text
    #Definer output stien
    $outputFile = "C:\temp\PingLog.txt"

    #Laver en popup med en OK og Cancel knap
    $a = new-object -comobject wscript.shell 
$intAnswer = $a.popup("Are you sure you want to ping $ip.
(Program will freeze when pinging)

Press Cancel to exit", 0,"Pinger",1) 
If ($intAnswer -eq 1) { 

#Hvis der bliver klikket cancel, bliver scriptet terminated
} else { 
    $a.popup("Pinging will be cancled") 
    $terminateScript = $true
    $MainForm.Close()
    return $terminateScript 
} 

    #Hvis count bliver sat til 0, så bilver nedstående kode kørt.
    if ($count -eq 0) {
        while ($true) { #Laver en while loop som kører for evigt (indtil program bliver lukket)
            test-connection $ip -count 1 | Select-Object @{n='TimeStamp';e={Get-Date}},__SERVER, Address, ProtocolAddress, ResponseTime | out-file -append $outputFile
            Start-Sleep $delay #Kører en ping hvert $delay sekund
            }
    }
    #Kører normal ping med delay og count
    else {
    test-connection $ip -delay $delay -count $count | Select-Object @{n='TimeStamp';e={Get-Date}},__SERVER, Address, ProtocolAddress, ResponseTime | out-file -append $outputFile
    
    #Giver en popup når den er færdig med at ping
    [System.Windows.Forms.MessageBox]::Show("Pinging finished!
    
    Please check outputfile for info 
    $outputFile" , "Done")        
    }
    
})

$Form.ShowDialog()
}
Form

