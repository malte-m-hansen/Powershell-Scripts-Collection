#Laver en basic form
Function Form {
    Add-Type -AssemblyName System.Windows.Forms
    $Form = New-Object system.Windows.Forms.Form
    #Titel på Formen
    $Form.Text = "Process Killer"
    #Højde og bredde
    $Form.width = 200
    $Form.height = 150
    #Fjerner Maximer og Minimer knapper
    $Form.MinimizeBox = $False
    $Form.MaximizeBox = $False
    $Form.WindowState = "Normal"
    $Form.SizeGripStyle = "Hide"
    
    #Process Name Label
    $Label = New-Object System.Windows.Forms.Label
    #Placering af Label1
    $Label.Location = New-Object System.Drawing.Size(10, 10) 
    #Størrelse på Label1
    $Label.Size = New-Object System.Drawing.Size(160, 20) 
    #Text på Label1
    $Label.Text = "Process Name to kill"
    $Form.Controls.Add($Label) 
    
    #Textbox
    $TextBox = New-Object System.Windows.Forms.TextBox 
    $TextBox.Location = New-Object System.Drawing.Size(10, 30) 
    $TextBox.Size = New-Object System.Drawing.Size(150, 20) 
    $Form.Controls.Add($TextBox) 
    
    #OK/Confirm Knap
    $OKButton = new-object System.Windows.Forms.Button
    $OKButton.Location = '10,60'
    $OKButton.Size = '100,30' 
    #Tekst der skal stå på knappen
    $OKButton.Text = 'Kill Process'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $OKButton
    $form.Controls.AddRange(@($OKButton)),
    #Hvad der skal ske når man klikker på knappen
    $OKButton.Add_Click(
        {
            #Definer $name som det der står i $TextBox, når der bliver trykket på knappen
            $name = $TextBox.Text
        
            #laver et nyt oblect der hedder $a
            $a = new-object -comobject wscript.shell 
            #Laver en popup der spørger om du vil "kill" process 
            $intAnswer = $a.popup("Are you sure you want to kill $name.
    
Press Cancel to exit", 0, "Process Killer", 1) 
            #Hvis der bliver svarret "nej" vil den cancel og terminate scriptet 
            If ($intAnswer -eq 1) { 
                #Stopper den process som hedder det man tastede ind i tekstfeltet
                Stop-Process -Name "$name"
                #Laver en popup, og når man har klikket OK i den, lukker programmet
                [System.Windows.Forms.MessageBox]::Show("Done" , "Done")
            }
            else { 
                #laver en popup der infomere om at du ikke stoppede processen, derefter stopper scriptet
                $a.popup("Program ended. Process not terminated") 

            }
        })
    
    $Form.ShowDialog()
}
Form
    
    