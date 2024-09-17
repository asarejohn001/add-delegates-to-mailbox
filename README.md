## Add a delegate to a mailbox

# Scenario
You have disabled all intern's accounts, and you want to grant their supervisor access to their mailbox.
You can grant the supervisor's [fullAccess](https://learn.microsoft.com/en-us/microsoft-365/admin/add-users/give-mailbox-permissions-to-another-user?view=o365-worldwide#read-email-in-another-users-mailbox) to fully manages the mailbox or [sendAs Access](https://learn.microsoft.com/en-us/microsoft-365/admin/add-users/give-mailbox-permissions-to-another-user?view=o365-worldwide#send-email-from-another-users-mailbox) to send email as the initial mailbox owner.

Imagine you have to do this to more than 10 users. It is best to use a script.

# About the script, [add-delegates-to-mailbox.ps1](add-delegates-to-mailbox.ps1)
I wrote the script to:
1. Connect to EAC using [Connect-ExchangeOnline](https://learn.microsoft.com/en-us/powershell/module/exchange/connect-exchangeonline?view=exchange-ps). This is the best method if your environment uses MFA authentication.
2. Import in the CSV file. The file should have two columns - one with the owner of the mailbox and the other with the delegates. Check out [delegatesInfo.csv](delegatesInfo.csv) for reference.
3. There are 3 [try-catch](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_try_catch_finally?view=powershell-7.4) block of codes.
4. [Add-MailboxPermission](https://learn.microsoft.com/en-us/powershell/module/exchange/add-mailboxpermission?view=exchange-ps) will grant the delegate full access to the mailbox.
5. [Add-RecipientPermission](https://learn.microsoft.com/en-us/powershell/module/exchange/add-recipientpermission?view=exchange-ps) will grant the delegate permission to send email as the mailbox owner.
6. Using [Set-Mailbox](https://learn.microsoft.com/en-us/powershell/module/exchange/set-mailbox?view=exchange-ps) and [GrantSendOnBehalfTo](https://learn.microsoft.com/en-us/exchange/recipients-in-exchange-online/manage-permissions-for-recipients#use-exchange-online-powershell-to-assign-the-send-on-behalf-permission-to-mailboxes-and-groups) will permit the delegate to send an email on behalf of the mailbox owner.
7. All activities will log into [log.txt](log.txt) for review.
