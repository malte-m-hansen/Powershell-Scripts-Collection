#TODO Implement file browser

#Laver en basic form
Function Form {
    Add-Type -AssemblyName System.Windows.Forms
    $Form = New-Object system.Windows.Forms.Form
    #Titel på Formen
    $Form.Text = "User Manager"
    #Højde og bredde
    $Form.width = 250
    $Form.height = 250
    #Fjerner Maximer og Minimer knapper
    $Form.MinimizeBox = $False
    $Form.MaximizeBox = $False
    $Form.WindowState = "Normal"
    $Form.SizeGripStyle = "Hide"
    
    #Process Name Label
    $Label = New-Object System.Windows.Forms.Label
    #Placering af Label1
    $Label.Location = New-Object System.Drawing.Size(15, 60) 
    #Størrelse på Label1
    $Label.Size = New-Object System.Drawing.Size(200, 30) 
    #Text på Label1
    $Label.Text = "Path to CSV
(CSV should only contain UserName)"
    $Form.Controls.Add($Label) 
    
    #Textbox
    $TextBox = New-Object System.Windows.Forms.TextBox 
    $TextBox.Location = New-Object System.Drawing.Size(15, 90) 
    $TextBox.Size = New-Object System.Drawing.Size(200, 20) 
    $Form.Controls.Add($TextBox) 
    
    # Create a group that will contain your radio buttons
    $GroupBox = New-Object System.Windows.Forms.GroupBox
    $GroupBox.Location = '15,0'
    $GroupBox.size = '200,50'
    
    # Create the collection of radio buttons
    $RadioButton1 = New-Object System.Windows.Forms.RadioButton
    $RadioButton1.Location = '10,15'
    $RadioButton1.size = '90,20'
    $RadioButton1.Checked = $true 
    $RadioButton1.Text = "Create Users"
 
    $RadioButton2 = New-Object System.Windows.Forms.RadioButton
    $RadioButton2.Location = '105,15'
    $RadioButton2.size = '88,20'
    $RadioButton2.Checked = $false
    $RadioButton2.Text = "Delete Users"

    #OK/Confirm Knap
    $OKButton = new-object System.Windows.Forms.Button
    $OKButton.Location = '50,120'
    $OKButton.Size = '100,30' 
    #Tekst der skal stå på knappen
    $OKButton.Text = 'Go!'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton



    $form.Controls.AddRange(@($GroupBox, $OKButton))
    $GroupBox.Controls.AddRange(@($Radiobutton1, $RadioButton2))
    
    #Hvad der skal ske når man klikker på knappen
    $OKButton.Add_Click(
        {
            #Definerer $path som det der står i text felt
            #TODO Brug "Test-Path" for at tjekke om filen eksistere (samme som fra opgave 3b)
            $path = $TextBox.Text
            #Hvis "Create Users" er klikket, køres denne blok kode
            if ($RadioButton1.Checked -eq $true) {
                #Importere den valgte CSV fil
                Import-Csv $path |
                    #Kører denne blok kode for hver "entry" i csv filen
                    ForEach-Object {
                    $username = $_.UserName
                    #laver en ny bruger med brugernavn, og uden kode
                    #TODO tekstfelt hvor man kan skrive en "standard kode" til alle brugerne
                    #TODO Gør så den selv kan tjekke om man har password i CSV filen, og hvis der er, så bruger den det password.
                    New-LocalUser -Name $username -NoPassword
                    #Laver en popup hvor der står når en bruger er lavet
                    [System.Windows.Forms.MessageBox]::Show("$username has been created" , "Done")  
                }
                
            }
            
            #Kører denne blok kode, når "delete users" er valgt
            else {
                #Importere CSV filen      
                Import-Csv $path |
                    ForEach-Object {
                    $username = $_.UserName
                    Remove-LocalUser -Name $username
                    [System.Windows.Forms.MessageBox]::Show("$username has been removed" , "Done")  
                }
                 
            }
        })
    
    $Form.ShowDialog()
}
Form
    
