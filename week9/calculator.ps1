#3. Write a program that can start and stop the Windows Calculator only using Powershell and using only the process name for the Windows Calculator (to start and stop it).

# Open and close calculator
Start-Process -FilePath "C:Windows\System32\calc.exe"
sleep 2
Stop-Process -Name win32calc