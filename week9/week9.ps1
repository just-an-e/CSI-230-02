#Story
#Display DHCP server's IP address and the DNS server IPs
#Export your list of running processes and running services on your system into separate files.

# Directory to save files:
$myDir = "C:\Users\Justin\Desktop\"
# Get the DHCP server IP. 
ipconfig /all | Select-String -Pattern "DHCP Server"
# Get the DNS server IP.
ipconfig /all | Select-String -Pattern "\d\.\d\.\d\.\d"

# Get running processes 
Get-Process | Select-Object ProcessName, Path, ID | `
Export-Csv -Path "$myDir\myProcesses.csv" -NoTypeInformation

# Get running services
Get-Service | Where { $_.Status -eq "Running" } | Select-Object DisplayName, Status |`
Export-Csv -Path "$myDir\myServices.csv" -NoTypeInformation