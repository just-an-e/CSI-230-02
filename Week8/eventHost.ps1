# Storyline: Review the Security Event Log

$myDir = "C:\Users\Justin\Desktop\"

# List all the available Windows Event Logs
Get-EventLog -List 

# Create a prompt to allow user to select the Log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"

#select the phrase to search for
$searchPhrase = Read-Host -Prompt "Please type out a word or phrase you would like to search the log for"

#Print the results for the log
Get-EventLog -LogName $readLog -Newest 30 | where {$_.Message -ilike "*$searchPhrase*"} | export-csv -NoTypeInformation `
-LiteralPath "securityLogs.csv"

