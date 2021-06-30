#Check recent logons

Write-Host "`r`n[+] Teminal Services Logons:`r`n"
Write-Host "++++++++++++++++++++++++`r`n"

#Set before and after dates as variables

$dte = Get-Date
$Before = $dte
$After = $dte.AddDays(-1)

Get-WinEvent -FilterHashtable @{ LogName='Security'; StartTime=$After; EndTime=$Before; Id='4624'}|Where{$_.Message -match "Logon Type:\s+10"}|Select TimeCreated,Message

#Script to check the contents of the startup folder

Write-Host "`r`n[+] Startup Folder Contents: `r`n"
$path = 'C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\*'
Get-ChildItem $path | Where-Object {$_.name -ne 'desktop.ini'}


#Script to check WMI Subscriptions:

Write-Host "`r`n[+] WMI Subscriptions:`r`n"
Write-Host "+++++++++++++++++++++++++"
Get-WmiObject -Namespace root/Subscription -Class __EventFilter

#Script to list processes

Write-Host "Processes"
Write-Host "+++++++++++++++++++++"
$processes = Get-Process *


#quick one-liner script to identify wmiobjects

Get-WmiObject win32_service | select Name, DisplayName | Format-List


#This script queries scheduled tasks and Searches the content in the tasks for any commands being run to indentify persistence.

$tasks = Get-ChildItem "C:\Windows\System32\Tasks" -Recurse

ForEach ($task in $tasks) {
    Write-Host "`r`n[+] Task: $task"
    Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++`r`n"
    Get-Content $task -ErrorAction SilentlyContinue | Select-String -Pattern '<command>' -SimpleMatch
}

#RUN AS ADMINISTRATOR

#Search for recently written files

Write-Host "`r`nRecently Written Files: `r`n"
Write-Host "++++++++++++++++++++++++++`r`n"

$recentFiles = Get-ChildItem -Path C:\ -Filter =.exe -Recurse -ErrorAction SilentlyContinue -Force|? {$_.LastWriteTime -gt (Get-Date).AddDays(-1)}|select -exp FullName

ForEach($file in $recentFiles){
    Write-Host $file
    }



#Check for Alternate Data Streams:

Write-Host "`r`nFiles with ADS: `r`n"
Write-Host "+++++++++++++++++++++++++++`r`n"

ForEach ($file in $recentFiles){
    Get-Item $file -Stream * | Where-Object stream -NE ':$Data'
    }


#This script will check the local machine for keys set to run or runOnce. This is to detect persistence on the machine.

$sysKeys = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run", "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce"

ForEach($key in $sysKeys){
    Get-ItemProperty Registry::$key
    }


$users = (Get-WmiObject Win32_UserProfile | Where-Object { $_.SID -notmatch 'S-1-5-(18|19|20).*' })
$userPaths = $users.localpath
$userSIDS = $users.sid

for ($counter=0; $counter -lt $users.length; $counter++){
    $path = $users[$counter].localpath
    $sid = $users[$counter].sid
    reg load hku\$sid $path\ntuser.dat
}

Get-ItemProperty Registry::\hku\*\software\microsoft\windows\currentversion\run;
Get-ItemProperty Registry::\hku\*\software\microsoft\windows\currentversion\runonce;

ForEach($key in $sysKeys){
    Get-ItemProperty Registry::$key
}