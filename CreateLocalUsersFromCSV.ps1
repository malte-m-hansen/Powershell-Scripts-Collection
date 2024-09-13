Import-Csv C:\temp\users.csv |
ForEach-Object {
    $username = $_.UserName
    New-LocalUser -Name $username -NoPassword
}