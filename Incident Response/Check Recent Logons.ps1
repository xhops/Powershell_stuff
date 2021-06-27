#Check recent logons

Write-Host "`r`n[+] Teminal Services Logons:`r`n"
Write-Host "++++++++++++++++++++++++`r`n"

#Set before and after dates as variables

$Before = Get-Date 2021/06/27
$After = Get-Date 2021/06/26

Get-WinEvent -FilterHashtable @{ LogName='Security'; StartTime=$After; EndTime=$Before; Id='4624'}|Where{$_.Message -match "Logon Type:\s+10"}|Select TimeCreated,Message

