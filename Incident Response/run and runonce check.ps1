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