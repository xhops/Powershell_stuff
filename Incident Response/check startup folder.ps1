#Script to check the contents of the startup folder

Write-Host "`r`n[+] Startup Folder Contents: `r`n"
$path = 'C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*'
Get-ChildItem $path | Where-Object {$_.name -ne 'desktop.ini'}