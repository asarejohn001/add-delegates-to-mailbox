<#
Name: John Asare
Date: 09/13/2024

Description: Read more about this script from 
#>

# Install module if not already
#Install-Module -Name ExchangeOnlineManagement

# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName "yourEXOadminaccount@example.com"

# Path to the CSV file
$csvPath = ".\delegatesInfo.csv"

# Import CSV file
$users = Import-Csv -Path $csvPath

#Initiate script progress
Write-Host "Script is running..."

# Loop through each row in the CSV and add mailbox permissions
foreach ($user in $users) {
    $Mailbox = $user.Mailbox.Trim()
    $User = $user.User.Trim()

    # Grant FullAccess permission
    try {
        Add-MailboxPermission -Identity $Mailbox -User $User -AccessRights FullAccess -InheritanceType All -AutoMapping $true -Confirm:$false
        Get-Log -LogMessage "Successfully added FullAccess permission for $User on $Mailbox." -LogFilePath $logFilePath
        Write-Host "Done, check log file"
    }
    catch {
        Get-Log -LogMessage "Failed to add FullAccess permission for $User on $Mailbox. Error: $_" -LogFilePath $logFilePath
        Write-Host "Done with error, check log file" -ForegroundColor Red
    }

    # Grant SendAs permission
    try {
        Add-RecipientPermission -Identity $Mailbox -Trustee $User -AccessRights SendAs -Confirm:$false
        Get-Log -LogMessage "Successfully added SendAs permission for $User on $Mailbox." -LogFilePath $logFilePath
        Write-Host "Done, check log file"
    }
    catch {
        Get-Log -LogMessage "Failed to add SendAs permission for $User on $Mailbox. Error: $_" -LogFilePath $logFilePath
        Write-Host "Done with error, check log file" -ForegroundColor Red
    }

    # Grant Send on Behalf permission
    try {
        Set-Mailbox -Identity $Mailbox -GrantSendOnBehalfTo @{Add=$User}
        Get-Log -LogMessage "Successfully added SendOnBehalf permission for $User on $Mailbox." -LogFilePath $logFilePath
        Write-Host "Done, check log file"
    }
    catch {
        Get-Log -LogMessage "Failed to add SendOnBehalf permission for $User on $Mailbox. Error: $_" -LogFilePath $logFilePath
        Write-Host "Done with error, check log file" -ForegroundColor Red
    }
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
