#Script to check WMI Subscriptions:

Write-Host "`r`n[+] WMI Subscriptions:`r`n"
Write-Host "+++++++++++++++++++++++++"
Get-WmiObject -Namespace root/Subscription -Class __EventFilter