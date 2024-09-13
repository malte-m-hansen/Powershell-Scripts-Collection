#Define a bunch of global parameters, thats used in functions
Param (
    $global:titlevalue = 0,
    $global:topicvalue = 0,
    $global:messagevalue = 0,
    $global:ltvalue = 0,
    $global:SelectedFile = 0,
    $global:cat = 0
)
#*AutoFill initials
#$unameautofill = $env:username

#*Autofill Laptop Name
#$ltname = $env:computername

#*Get Current User. Usedin "Get AD Location"
$CurrentUserName = $env:username

#*Get AD User Location
#$CurrentUserDetails = Get-ADuser $CurrentUserName -Properties *
$adsite = $CurrentUserDetails.l 

#File Browser fonction
Function Get-FileName {
    Add-Type -AssemblyName System.Windows.Forms
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
        Multiselect = $true # Multiple files can be chosen
        Filter      = 'All files (*.*)| *.*' # Specified file types
    }
    [void]$FileBrowser.ShowDialog()
    $path = $FileBrowser.FileNames;
    If ($FileBrowser.FileNames -like "*\*") {

        # Do something before work on individual files commences
        $FileBrowser.FileNames #Lists selected files (optional)
        $Global:SelectedFile = $FileBrowser.FileNames
        foreach ($file in Get-ChildItem $path) {
            Get-ChildItem ($file) |
                ForEach-Object {
            }
        }
    }
    else { #Do something if user canceled file browser 
        #//Write-Host "Cancelled by user"
    }
    #Runs CheckAttValue every time the file browser window is closed
    CheckAttValue
}

Function CheckAttValue {
    if ($SelectedFile -gt "0") { #If a file has been selected, Remove "Add Att button" and replace it with "Remove Att Button"
        $AttTextLabel.Text = "Attachments Added"
        $AttTextLabel.Refresh()
        $AttRemoveButton.Size = '100,40'
        $AttButton.Size = '0,0'
    }
    else { #If a file is not selected, say "Att removed"
        $AttTextLabel.Text = "Attachments Removed"
    }
}
Function RemoveAtt { #This function is run when "Remove Att button" is pressed. Hides "remove att button" and makes "Add att button" visable again
    $global:SelectedFile = "0"
    $AttRemoveButton.Size = '0,0'
    $AttButton.Size = '100,40'
    CheckAttValue
} 






# Sets xvalue to one, and checks if all values are 1 everytime something is typed in the fields, Then sets OK button to enabled
#These 3 Functions can be optimised alot....
function AddTitleValue ($titlevalue) {
    if ($TextBox.Text.Length -gt 0) {
        $global:titlevalue = 1
        if (($global:titlevalue -eq 1) -and ($global:topicvalue -eq 1) -and ($global:messagevalue -eq 1)) {$OKButton.Enabled = $true}
    }
    elseif ($TextBox.Text.Length -lt 1) {
        $global:titlevalue = 0
        $OKButton.Enabled = $false
    }
}

function AddTopicValue ($topicvalue) {
    if ($TextBox2.Text.Length -gt 0) {
        $global:topicvalue = 1
        if (($global:titlevalue -eq 1) -and ($global:topicvalue -eq 1) -and ($global:messagevalue -eq 1)) {$Button.Enabled = $true}
    }
    elseif ($TextBox2.Text.Length -lt 1) {
        $global:topicvalue = 0
        $OKButton.Enabled = $false
    }
}


function AddMessageValue ($messagevalue) {
    if ($TextBox3.Text.Length -gt 0) {
        $global:messagevalue = 1
        if (($global:titlevalue -eq 1) -and ($global:topicvalue -eq 1) -and ($global:messagevalue -eq 1)) {$OKButton.Enabled = $true}
    }
    elseif ($TextBox3.Text.Length -lt 1) {
        $global:messagevalue = 0
        $OKButton.Enabled = $false
    }
}

function AddLTValue ($ltvalue) {    #Sets ltvalue to 1 if "Lt Text" has been changed once.
                                    #This can cause trouble if the field is empty again after something has been typed. Should be fixed using an IF statement     
    $global:ltvalue = 1
}

# A function to create the form 
function Form {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
    
    # Set the size of your form
    $Form = New-Object System.Windows.Forms.Form
    $Form.width = 500
    $Form.height = 550
    $Form.Text = ”Submit Ticket"
    $Form.StartPosition = "CenterScreen"
    $Form.FormBorderStyle = 'Fixed3D'
    $Form.MaximizeBox = $false
 
    #¤ Set the font of the text to be used within the form"
    $Font = New-Object System.Drawing.Font("Calibri Light", 11)
    $Form.Font = $Font

    #¤ Ticket Sender/Initials
    $Label = New-Object System.Windows.Forms.Label
    $Label.Location = New-Object System.Drawing.Size(40, 200) 
    $Label.Size = New-Object System.Drawing.Size(280, 20) 
    $Label.Text = "Your initials:"
    $Form.Controls.Add($Label) 

    $TextBox = New-Object System.Windows.Forms.TextBox 
    $TextBox.Location = New-Object System.Drawing.Size(40, 220) 
    $TextBox.Size = New-Object System.Drawing.Size(260, 20) 
    $TextBox.add_TextChanged( {AddTitleValue})
    $TextBox.Text = $unameautofill
    $Form.Controls.Add($TextBox) 

    #¤ Ticket Topic
    $Label2 = New-Object System.Windows.Forms.Label
    $Label2.Location = New-Object System.Drawing.Size(40, 260) 
    $Label2.Size = New-Object System.Drawing.Size(280, 20) 
    $Label2.Text = "Ticket Title:"
    $Form.Controls.Add($Label2) 

    $TextBox2 = New-Object System.Windows.Forms.TextBox 
    $TextBox2.Location = New-Object System.Drawing.Size(40, 280) 
    $TextBox2.Size = New-Object System.Drawing.Size(260, 20) 
    $TextBox2.add_TextChanged( {AddTopicValue})
    $TextBox2.Select()
    $Form.Controls.Add($TextBox2) 

    #¤ Ticket Message
    $Label3 = New-Object System.Windows.Forms.Label
    $Label3.Location = New-Object System.Drawing.Size(40, 320) 
    $Label3.Size = New-Object System.Drawing.Size(180, 20) 
    $Label3.Text = "Ticket Description:"
    $Form.Controls.Add($Label3) 

    $TextBox3 = New-Object System.Windows.Forms.TextBox 
    $TextBox3.Location = New-Object System.Drawing.Size(40, 340) 
    $TextBox3.Size = New-Object System.Drawing.Size(260, 90) 
    $TextBox3.add_TextChanged( {AddMessageValue})
    $TextBox3.MultiLine = $True
    $TextBox3.Scrollbars = "Vertical" 
    $Form.Controls.Add($TextBox3) 

    #¤ Laptop Name
    $Label4 = New-Object System.Windows.Forms.Label
    $Label4.Location = New-Object System.Drawing.Size(320, 200) 
    $Label4.Size = New-Object System.Drawing.Size(280, 20) 
    $Label4.Text = "Laptop Name:"
    $Form.Controls.Add($Label4) 

    $TextBox4 = New-Object System.Windows.Forms.TextBox 
    $TextBox4.Location = New-Object System.Drawing.Size(320, 220) 
    $TextBox4.Size = New-Object System.Drawing.Size(100, 20) 
    $TextBox4.add_TextChanged( {AddLTValue})
    $TextBox4.Text = $ltname
    $Form.Controls.Add($TextBox4) 

    #¤ Other Location
    $TextBox5 = New-Object System.Windows.Forms.TextBox 
    $TextBox5.Location = New-Object System.Drawing.Size(227, 93) 
    $TextBox5.Size = New-Object System.Drawing.Size(130, 20) 
    $TextBox5.Enabled = $false
    $Form.Controls.Add($TextBox5) 

    #¤ TICKET CATEGORY! Too lazy to cange $LabelTriedThis to $LabelTicketCat
    $LabelTriedThis = New-Object System.Windows.Forms.Label
    $LabelTriedThis.Location = New-Object System.Drawing.Size(320, 260) 
    $LabelTriedThis.Size = New-Object System.Drawing.Size(200, 20) 
    $LabelTriedThis.Text = "Ticket Category:"
    $Form.Controls.Add($LabelTriedThis) 


    #Create List box with categories
    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Location = New-Object System.Drawing.Point(320, 290)
    $listBox.Size = New-Object System.Drawing.Size(140, 20)
    $listBox.Height = 80

    [void] $listBox.Items.Add('None')
    [void] $listBox.Items.Add('Software')
    [void] $listBox.Items.Add('Special Software')
    [void] $listBox.Items.Add('Hardware')
    [void] $listBox.Items.Add('Permissions')
    [void] $listBox.Items.Add('DAX')
    [void] $listBox.Items.Add('Account Changes')
    [void] $listBox.Items.Add('Sharepoint')
    [void] $listBox.Items.Add('Microsoft Office')

    $form.Controls.Add($listBox)

    $form.Topmost = $true


    #¤ Create a group that will contain your radio buttons
    $MyGroupBox = New-Object System.Windows.Forms.GroupBox
    $MyGroupBox.Location = '40,30'
    #¤ To remove Radio Buttons, change size from "400,150" to "0,0"
    $MyGroupBox.size = '400,150'
    $MyGroupBox.text = "What is your Lcation?"


    #¤ Create the collection of radio buttons
    $RadioButton1 = New-Object System.Windows.Forms.RadioButton
    $RadioButton1.Location = '20,40'
    $RadioButton1.size = '150,20'
    $RadioButton1.Add_Click( { $TextBox5.Enabled = $false })
    $RadioButton1.Add_Click( { $TextBox5.Clear() })
    $RadioButton1.Checked = $false
    $RadioButton1.Text = "Ikast, Denmark"
    if ($adsite -contains "Ikast") {
        $RadioButton1.Checked = $true
    }

    $RadioButton2 = New-Object System.Windows.Forms.RadioButton
    $RadioButton2.Location = '20,70'
    $RadioButton2.size = '150,20'
    $RadioButton2.Add_Click( { $TextBox5.Enabled = $false })
    $RadioButton2.Add_Click( { $TextBox5.Clear() })
    $RadioButton2.Checked = $false
    $RadioButton2.Text = "Szczecin, Poland"
    if ($adsite -contains "Szczecin") {
        $RadioButton2.Checked = $true
    }
    
    $RadioButton3 = New-Object System.Windows.Forms.RadioButton
    $RadioButton3.Location = '20,100'
    $RadioButton3.size = '150,20'
    $RadioButton3.Add_Click( { $TextBox5.Enabled = $false })
    $RadioButton3.Add_Click( { $TextBox5.Clear() })
    $RadioButton3.Checked = $false
    $RadioButton3.Text = "Bangalore, India"
    if ($adsite -contains "Bangalore") {
        $RadioButton3.Checked = $true
    }

    $RadioButton4 = New-Object System.Windows.Forms.RadioButton
    $RadioButton4.Location = '170,40'
    $RadioButton4.size = '150,20'
    $RadioButton4.Add_Click( { $TextBox5.Enabled = $true })
    $RadioButton4.Checked = $false
    $RadioButton4.Text = "Other, Please specify"

    

    #¤ Add an OK button
    $OKButton = new-object System.Windows.Forms.Button
    $OKButton.Location = '50,450'
    $OKButton.Size = '100,40' 
    $OKButton.Text = 'Submit'
    $OKButton.Enabled = $false
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
 
    #¤ Add a cancel button
    $CancelButton = new-object System.Windows.Forms.Button
    $CancelButton.Location = '200,450'
    $CancelButton.Size = '100,40'
    $CancelButton.Text = "Cancel"
    #//$OKButton.DialogResult=[System.Windows.Forms.DialogResult]::Cancel

    $AttButton = new-object System.Windows.Forms.Button
    $AttButton.Location = '350,450'
    $AttButton.Size = '100,40'
    $AttButton.Text = "Add Attachments"
    $AttButton.Add_Click( { Get-FileName })

    $AttTextLabel = New-Object System.Windows.Forms.Label
    $AttTextLabel.Location = New-Object System.Drawing.Size(349, 410) 
    $AttTextLabel.Size = New-Object System.Drawing.Size(120, 40) 
    $AttTextLabel.Font = New-Object System.Drawing.Font("Calibri Light", 9)
    $AttTextLabel.Text = "Please add all Attachments at once"
    $Form.Controls.Add($AttTextLabel) 

    $AttRemoveButton = new-object System.Windows.Forms.Button
    $AttRemoveButton.Location = '350,450'
    $AttRemoveButton.Size = '0,0'
    $AttRemoveButton.Text = "Remove Attachments"
    $AttRemoveButton.Add_Click( { RemoveAtt })

    #¤ Add all the Form controls on one line 
    $form.Controls.AddRange(@($MyGroupBox, $OKButton, $CancelButton, $AttButton, $AttRemoveButton))
    
    #¤ Add all the GroupBox controls on one line
    $MyGroupBox.Controls.AddRange(@($Radiobutton1, $RadioButton2, $RadioButton3, $RadioButton4))
    
    #¤ Assign the Accept and Cancel options in the form to the corresponding buttons
    $form.AcceptButton = $OKButton
    $form.CancelButton = $CancelButton

    #¤ Activate the form
    $form.Add_Shown( {$form.Activate()})    

    #¤ Get the results from the button click
    $dialogResult = $form.ShowDialog()
    
    #! If the OK button is selected
    if ($dialogResult -eq "OK") {

        $cat = $listBox.SelectedItem
        #        $cat
        #        $cattext

        #¤ Check the current state of each radio button and respond accordingly
        if ($RadioButton1.Checked) {
            $TextLocation = "Location: Ikast, Denmark"
        }
        elseif ($RadioButton2.Checked) {
            $TextLocation = "Location: Szczecin, Poland"
        }
        elseif ($RadioButton3.Checked) {
            $TextLocation = "Location: Bangalore, India"
        }
        elseif ($RadioButton4.Checked) {
            $TextLocation = "Location: " + $TextBox5.Text 
        }

        if ($cat -gt 0) {
            $cattext = "[Category: " + $cat + "] "
        }

        else {
            $cattext = ""
        }


        #¤ Ticket Sender + adding domain.com
        $mailsender = $TextBox.Text + "@domain.com"

        #¤ Defines What is in Ticket Topic Text
        $mailtopic = $cattext + $TextBox2.Text




        if ($ltvalue -eq 1) {
            $ltcheck = "Laptop Name: "
        }

        else {
            $ltcheck = " "
        }
    
        $lttext = $ltcheck + $ltname

        #¤ Ticket Description + Laptop Name + Location
        #!##########This is the message itself################

        $mailmessage = $TextBox3.Text + " 
 
" + $lttext + "

" + $TextLocation + "

" 

        #!#############END OF MESSAGE#########################
        # Send the mail
        $Mailreceiver = "test-inbox@domain.com" #Defines reciver. Should be servicedesk@domain.com
        $Mailserver = "domain-com.mail.protection.outlook.com" #Defines SMPT server

        if ($global:SelectedFile -gt "0") { 
            Send-MailMessage -To "$mailreceiver" -from "$mailsender" -smtpserver "$Mailserver" "$mailtopic" "$mailmessage" -Attachments $SelectedFile
        }
        else {
            Send-MailMessage -To "$mailreceiver" -from "$mailsender" -smtpserver "$Mailserver" "$mailtopic" "$mailmessage"
        }

        #¤ Mail Sent Popup
        [System.Windows.Forms.MessageBox]::Show("Your ticket with the title '$mailtopic' has been sucessfully sent to the ServiceDesk

Thank You" , "Ticket Sucessfully Submitted $cat")        
    } 
    #¤ Creates a popup when canceling.
    if ($dialogResult -eq "Cancel") {

        [System.Windows.Forms.MessageBox]::Show("Your ticket has not been sent!" , "Ticket not sent") 

        $cat = $listBox.SelectedItem

        # Prints Prints all these text fields to terminal, only when canceling
#              "Titlevalue = $titlevalue"
#              "Topicvalue = $topicvalue"
#              "Messagevalue = $messagevalue"
#              "Ltvalue = $ltvalue"
#              "UnameAutoFill = $unameautofill"
#              "ltname = $ltname"
#               "ADsite = $adsite"
#                "File = $SelectedFile"
#                "Category = $cat"

    }
}
#¤ Call the entire script
Form